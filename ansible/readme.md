# Ansible to setup the VMs for Kubernetes - CKA Training

## Run Ansible with Sudo

ansible-playbook main.yaml -i host.ini -e "ansible_become_password="