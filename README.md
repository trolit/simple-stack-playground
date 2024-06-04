# simple-stack-playground

Required tools:
- Ansible
- Node.js
- Docker

## Instructions

### Configuring data center (PostgreSQL)

1. Prepare machine or VM
2. Complete steps 1-4 from [database/README](./database/README.md)
3. Test connection with `ansible postgres -m ping`
4. Adjust [credentials](./database/roles/postgres/vars/credentials.yaml) and [variables](./database/roles/postgres/vars/main.yaml)
5. Prepare `.env` file for `api`, according to the provided information
6. Encrypt `credentials.yaml` file with `ansible-vault`
7. Run playbook

    ```sh
    ansible-playbook setup.yaml --extra-vars "role=postgres" -K
    ```
