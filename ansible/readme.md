# Ansible to setup the VMs for Kubernetes - CKA Training

## Prerequisite
### VM
Have atleast 3 VM setup for this project

### Additional Files
**host.ini**
[cp]
*ip* ansible_ssh_user=*vmuser* ansible_ssh_pass="*vmPassword*\"

[nodes]
...

## Run Ansible
ansible-playbook main.yaml -i host.ini -e "ansible_become_password=vmPassword"