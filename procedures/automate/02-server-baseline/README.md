# How to use this section
The files in the directory perform the same manual basic configuration found in the [manual-configuration.md](../manual/02-system-config/manual-configuration.md), but automates the steps using Ansible best practices.



```
├── README.md 
├── ansible.cfg -> ../ansible.cfg       # Configures how Ansible behaves. Soft link to parent folder to simplify management.
├── files -> ../files                   # Files used in the basic configuration. Soft link to parent folder to simplify management.
├── group_vars                          # Host group specific variables.
├── host_vars                           # Host specific variables.
├── inventory -> ../inventory           # The main inventory to manage. Soft link to parent folder to simplify management.
├── playbook.yml                        # The main playbook that includes playbooks from the /playbooks directory. Customizable. 
├── playbooks                           # Playbooks used in the main playbook.yml.
    ├── 01-hostname.yml
    ├── 02-nmcli-network.yml
    ├── 03-subscription-manager.yml
    ├── 04-dnf-automatic.yml
    └── 05...
├── tasks                               # Playbooks converted to tasks test performance b/t include_playbooks and import_tasks/include_tasks called in tasks.yml.
    ├── 01-hostname.yml
    ├── 02-nmcli-network.yml
    ├── 03-subscription-manager.yml
    ├── 04-dnf-automatic.yml
    └── 05...
└── tasks.yml                           # The main playbook that includes/imports the tasks under /tasks directory. Customizable.
```

```
.
├── README.md                               # you are here
├── ansible.cfg                             # how ansible behaves
├── files                                   # common files
│   ├── kubernetes.repo                     
│   └── rhsm                                
├── 02-system-config                        # mirrors the manual procedure 02-system-config
│   ├── README.md
│   ├── ansible.cfg -> ../ansible.cfg       # soft link to above ansible.cfg
│   ├── files -> ../files                   # soft link to above files
│   ├── inventory -> ../inventory           # soft link to above inventory
│   ├── playbook.yml                        # main playbook that include_playbooks from playbooks/
│   └── playbooks
│       ├── a-hostname.yml
│       ├── b-nmcli-network.yml
│       ├── c-subscription-manager.yml
│       ├── d-yum-update.yml
│       ├── e-dnf-automatic.yml
│       └── f-enable-start-services.yml
└── inventory
    ├── group_vars                          # variables specific to inventory groups
    ├── host_vars                           # variables specific to host groups
    │   └── host.workbench.lab
    │       ├── a-hostname
    │       ├── b-network
    │       ├── c-purpose
    │       ├── d-packages
    │       ├── e-dnf-auto
    │       └── f-services
    └── inventory                           # static inventory file of hosts
```