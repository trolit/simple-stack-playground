#!/bin/bash

COLOR_OFF='\033[0m'
COLOR_RED='\033[0;91m'
COLOR_GREEN='\033[0;92m'
COLOR_YELLOW='\033[0;93m'
COLOR_PURPLE='\033[0;95m'

current_step=1

run_in_strict_mode() {
    set -T          # inherit DEBUG and RETURN trap for functions
    set -C          # prevent file overwrite by > &> <>
    set -E          # inherit -e
    set -e          # exit immediately on errors
    set -u          # exit on not assigned variables
    set -o pipefail # exit on pipe failure
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
    log $COLOR_PURPLE "NOTE" "${1}"
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

# ---------------------------------------------------------------------------------------

run_in_strict_mode

move_to_script_directory_if_needed

precheck

log_note "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"

log_note "This script performs quick start of 'simple-stack-playground' infrastructure in K8S cluster using Ansible and Terraform on preconfigured data. It does not have rollback feature so in case of any error, please try to re-run from step that caused error."

if ! is_action_confirmed "Do you want to run it?"; then
    log_note "Exiting..."

    exit 0
fi
