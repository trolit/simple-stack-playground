```sh
# 1. Create inventory (split items per role)

# 2. Create SSH key 
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_cass

# 3. Copy .pub to ~/.ssh/authorized_keys of inventory host(s)

# 4. Execute setup.yaml playbook for chosen role
ansible-playbook setup.yaml --extra-vars "role=cassandra" -K

```

### Examples

```sh
# test inventories
ansible all -m ping
```
