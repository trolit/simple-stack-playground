#!/bin/bash

COLOR_OFF='\033[0m'
COLOR_RED='\033[0;91m'
COLOR_CYAN='\033[0;96m'
COLOR_GREEN='\033[0;92m'
COLOR_YELLOW='\033[0;93m'

current_step=1
database_host=''
database_provider='postgres'

run_in_strict_mode() {
    set -T # inherit DEBUG and RETURN trap for functions
    set -C # prevent file overwrite by > &> <>
    set -E # inherit -e
    set -e # exit immediately on errors
    set -u # exit on not assigned variables
}

move_to_script_directory_if_needed() {
    local dirname=$(dirname $0)

    if [ "${dirname}" != "." ]; then
        cd $dirname
    fi
}

precheck() {
    # &>/dev/null - suppress stdout and stderr
    if ! command ansible --version &>/dev/null; then
        log_error "Ansible not found!"
    fi

    if ! command terraform --version &>/dev/null; then
        log_error "Terraform not found!"
    fi

    if ! command docker --version &>/dev/null; then
        log_error "Docker not found!"
    fi

    if ! command kubectl version &>/dev/null; then
        log_error "kubectl not found!"
    fi

    is_file_available "./database/inventory"
}

extract_database_host_from_inventory() {
    log_note "Attempting to extract [${database_provider}] database host from inventory.."

    database_host=$(grep -A2 "\[${database_provider}\]" ./database/inventory | grep -o -P '(?<=ansible_host=).*(?=( |$))')

    if [ -z "${database_host}" ]; then
        log_error "Extraction failed! Make sure that inventory includes [${database_provider}] entry with ansible_host definition below it!"
    fi

    sleep 0.2

    log_note "Host: ${database_host}"
}

log() {
    echo -e "$1[$2]: $3${COLOR_OFF}"
}

log_warning() {
    log $COLOR_YELLOW "WARNING" "${1}"
}

log_error() {
    log $COLOR_RED "ERROR" "${1}"

    exit 1
}

log_success() {
    log $COLOR_GREEN "SUCCESS" "${1}"
}

log_note() {
    log $COLOR_CYAN "NOTE" "${1}"
}

execute_step() {
    log_note "Step ${current_step}: $1"

    $2

    ((current_step++))
}

is_file_available() {
    if ! test -f "$1"; then
        log_error "File ${1} does not exist but is required to run script!"

        exit 1
    fi
}

is_action_confirmed() {
    local text=$1

    read -p "$(echo -e $text $COLOR_YELLOW"(y/n)"$COLOR_OFF) " choice

    case "$choice" in
    y | Y) return 0 ;;
    n | N) return 1 ;;
    *) is_action_confirmed "${text}" ;;
    esac
}

require_confirmation() {
    local text=$1

    read -p "$(echo -e $text $COLOR_YELLOW"(y/n)"$COLOR_OFF) " choice

    case "$choice" in
    y) ;;
    n) ;;
    *) is_action_confirmed "${text}" ;;
    esac

    if [ "${choice}" != 'y' ]; then
        log_note "Exiting..."

        exit 0
    fi
}

step_connection_test() {
    local result=$(bash -c "ansible "${database_provider}" -m ping")

    if grep -qi "unreachable" <<<"$result"; then
        log_error "Ping of [${database_provider}] includes unreachable host(s)! Check if specified host(s) have openssh-server installed and include public key of id_cass in ~/.ssh/authorized_keys file"
    fi
}

step_database_setup() {
    local result=$(ansible-playbook setup.yaml --extra-vars "role=${database_provider}" -K 2>&1 | tee /dev/tty)

    if grep -qE "(unreachable|failed)=[1-9]+[0-9]{0,}" <<<"$result"; then
        log_error "Running playbook failed!"
    fi
}

step_init_envs() {
    local example_env_filename='.env.example'
    local env_filename='.env'

    cp ${example_env_filename} ${env_filename}
    cp ./api/${example_env_filename} ./api/${env_filename}
    cp ./client/${example_env_filename} ./client/${env_filename}
}

step_adjust_database_connection_url() {
    sed -i "s/REPLACE_WITH_VALID_HOST/${database_host}/g" ./api/.env
}

step_build_images() {
    local result=$(docker compose build 2>&1 | tee /dev/tty)

    if grep -iq "error" <<<"$result"; then
        log_error "Failed to build Docker images!"
    fi
}

step_apply_infrastructure() {
    local result=$(terraform apply -auto-approve 2>&1 | tee /dev/tty)

    if ! grep -iq "Apply complete!" <<<"$result"; then
        log_error "Failed to apply infrastructure!"
    fi
}

step_migrate_database() {
    local pod_name=$(kubectl get pods -o=name | grep -o "api-.*")

    local result=$(kubectl exec -it ${pod_name} -- bash -c "npm run db:migrate:dev" 2>&1 | tee /dev/tty)

    if grep -iq "error" <<<"$result"; then
        log_error "Failed to perform database migration!"
    fi
}

# ---------------------------------------------------------------------------------------

run_in_strict_mode

move_to_script_directory_if_needed

precheck

log_note "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"

log_note "This script performs quick start of 'simple-stack-playground' infrastructure in K8S cluster using Ansible and Terraform on preconfigured data. It does not have rollback feature. In case of any error, try to re-run from particular step."

require_confirmation "Do you want to run it?"

# @TMP hardcoded because currently no other provider is possible to use for data center
extract_database_host_from_inventory "postgres"

require_confirmation "Is host correct?"

cd ./database

execute_step "Testing connection.." "step_connection_test"

execute_step "Preparing ${database_provider}.." "step_database_setup"

cd ..

execute_step "Creating env files.." "step_init_envs"

execute_step "Adjusting DATABASE_URL/SHADOW_DATABASE_URL.." "step_adjust_database_connection_url"

execute_step "Building Docker images.." "step_build_images"

cd ./infrastructure-as-code

execute_step "Applying infrastructure.." "step_apply_infrastructure"

execute_step "Migrating database.." "step_migrate_database"

log_success "Script completed. Access app at http://localhost:31000 or http://127.0.0.1:31000"

log_note "To destroy infrastructure, use 'terraform destroy'"
