```sh
# 1. Create inventory

# 2. Create SSH key 
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_cass

# 3. Copy .pub to ~/.ssh/authorized_keys of inventory host(s)

# 4. Execute playbooks (initialize -> install -> configure)
```

### Examples

```sh
# test inventories
ansible all -m ping

# run playbook (-K => prompt for password if needed)
ansible-playbook install-cassandra.yaml -K
```
