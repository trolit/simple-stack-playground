```sh
# 1. Create inventory (split items per role)

# 2. Create SSH key 
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_cass

# 3. Copy .pub to ~/.ssh/authorized_keys of inventory host(s)

# 4. Install openssh-server if host(s) don't have it

# 5. Execute setup.yaml playbook for chosen role
ansible-playbook setup.yaml --extra-vars "role=cassandra" -K
```

> [!NOTE]
> Cassandra repository was moved on 20.05 (https://apache.jfrog.io/ui/native/cassandra-deb) and it's not possible to install it that way. "Repository is not signed"

### Examples

```sh
# test inventories
ansible all -m ping
```
