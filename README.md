## Stack

- Docker
- Ansible
- Terraform
- Node.js, Vue, PostgreSQL
- K8S cluster ([setup with Docker Desktop](https://docs.docker.com/desktop/kubernetes/)), kubectl

## Preview

```
          +-----------------+
          |  K8S STATELESS  |
          |    CLUSTER      |
          |                 |
+-----+       +--------+    |
| WEB | <---> | CLIENT |    |
+-----+       +--------+    |
          |       ^         |
          |       |         |
          |       v         |
          |   +-------+       +----------+
          |   |  API  | <---> | POSTGRES |
          |   +-------+       +----------+
          |                 |
          +-----------------+
```

## Running project

1. Check if `ssh` is installed (`ssh -V`)
2. Create/own VM/machine with Unix based OS. It should have:

   - `openssh-server` installed
   - configured ssh connection with your machine

   <details>
   <summary>How to configure SSH connection?</summary>
      
   1. Generate key named `id_cass` (for different name, reflect change in [ansible.cfg](./database/ansible.cfg))

   ```sh
   sh-keygen -t rsa -b 4096 -f ~/.ssh/id_cass
   ```

   2. Paste public key (`~/.ssh/id_cass.pub`) content to `~/.ssh/authorized_keys` on VM/machine

   </details>

3. Check if current [become-directives](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-directives) in [setup.yaml](./database/setup.yaml) match VM/machine OS.

4. Get host of VM/machine using e.g. `ip a` and define `/database/inventory`

   ```sh
   [postgres]
   db1 ansible_host=192.168.0.7
   ```

   > Use `ansible postgres -m ping` to test if host is reachable. Note that for ping you might have to specify destination user (`ansible_user`).

### Quick start 🔥

1. Run `quick-start.sh` script from root dir.

### Manual start ⚙️

1. Go to `/database` and execute [setup.yaml](./database/setup.yaml) playbook for PostgreSQL role

   ```sh
   ansible-playbook setup.yaml --extra-vars "role=postgres" -K
   ```

2. Create `.env` files (x3) based on `.env.example`.

3. Modify `DATABASE_URL` and `SHADOW_DATABASE_URL` in `/api/.env` by replacing address (`127.0.0.1`) to the one that you've provided in `inventory`.

4. Go to root dir of project and build `client` and `api` images.

   ```
   npm run dc-build
   ```

5. Go to [/infrastructure-as-code](./infrastructure-as-code/) and call:

   ```sh
   terraform apply
   ```

   > If creating client service fails and you don't want to wait until K8S tries to resurrect it again, re-run it manually after few seconds

6. Run migrations by accessing `api`:

   ```sh
   # kubectl get pod
   kubectl exec --stdin --tty <POD-NAME> -- /bin/bash

   npm run db:migrate:dev
   ```

7. Access app at http://localhost:31000 or http://127.0.0.1:31000

8. Destroy stack using `terraform destroy`
