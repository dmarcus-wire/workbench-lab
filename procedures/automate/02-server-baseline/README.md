# How to use this section
The files in the directory perform the same manual basic configuration found in the [server baseline](procedures/manual/02-server-baseline), but automates the steps using Ansible best practices.

```
.
├── README.md
├── ansible.cfg -> ../ansible.cfg       # Configures how Ansible behaves. Soft link to parent folder to simplify management.
├── files -> ../files                   # Files used in the basic configuration. Soft link to parent folder to simplify management. 
├── inventory -> ../inventory           # The main inventory to manage. Soft link to parent folder to simplify management.
├── playbook.yml                        # The main playbook that includes playbooks from the /playbooks directory. Customizable.  
└── playbooks                           # Playbooks used in the main playbook.yml. Duplicate prefix compares modules vs. role implementation.
    ├── a-hostname.yml
    ├── b-network-role.yml
    ├── b-nmcli-network.yml
    ├── c-subscription-manager.yml
    ├── d-yum-update.yml
    ├── e-dnf-automatic.yml
    ├── f-enable-start-services.yml
    ├── g-rear.yml
    ├── h-virt-host.yml
    ├── i-linux-system-role-network.yml
    ├── j-storage-modules.yml
    ├── j-storage-role.yml
    ├── k-user-ssh.yml
    └── l-secure-host.yml
```