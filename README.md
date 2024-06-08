### Stack

- Node.js
- Ansible
- Docker
- Terraform
- K8S cluster ([setup with Docker Desktop](https://docs.docker.com/desktop/kubernetes/)), kubectl

### Preview

```
          +-----------------+
          |  K8S STATELESS  |
          |    CLUSTER      |
          |                 |
+-----+       +--------+    |
| WWW | <---> | CLIENT |    |
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

### Quick start

1. Check if `ssh` is installed (`ssh -V`)

2. Generate key named `id_cass`

   ```sh
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_cass
   ```

3. Go to `/database`

   1. Prepare Debian or other Unix OS based VM/machine and define `inventory`

      ```sh
      [postgres]
      db1 ansible_host=192.168.0.7
      ```

   2. Make sure that `db1` has `openssh-server` installed

      ```sh
      sudo apt install openssh-server
      ```

   3. Add public key (`~/.ssh/id_cass.pub`) to `~/.ssh/authorized_keys` file in `db1`

   4. Test connection

      ```sh
      ansible postgres -m ping
      ```

   5. Execute [setup.yaml](./database/setup.yaml) playbook for PostgreSQL role

      ```sh
      ansible-playbook setup.yaml --extra-vars "role=postgres" -K
      ```

      > [!WARNING]
      > Playbook uses `su root` to access sudoer user. For different command or username, adjust [setup.yaml](./database/setup.yaml) ([see become-directives](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-directives))

4. Create `.env` files (x3) based on `.env.example`.

5. Modify `DATABASE_URL` and `SHADOW_DATABASE_URL` in `/api/.env` by replacing address (`127.0.0.1`) to the one that you've provided in `inventory`.

6. Go to root dir of project and build `client` and `api` images.

   ```
   npm run dc-build
   ```

7. Go to [/infrastructure-as-code](./infrastructure-as-code/) and call:

   ```sh
   terraform apply
   ```

   > [!NOTE]
   > If creating client service fails and you don't want to wait until K8S tries to resurrect it again, re-run it manually after few seconds

8. Run migrations by accessing `api`:

   ```sh
   # kubectl get pod
   kubectl exec --stdin --tty <POD-NAME> -- /bin/bash

   npm run db:migrate:dev
   ```

9. Access app at http://localhost:31000 or http://127.0.0.1:31000

10. Destroy stack using `terraform destroy`
