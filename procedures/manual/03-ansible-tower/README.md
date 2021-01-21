# Install Ansible Tower bundle single machine
[source procedure](https://docs.ansible.com/ansible-tower/latest/html/quickinstall/download_tower.html)

1. download the latest setup: https://access.redhat.com/downloads/content/480
1. download and unpack the tar 
1. go to ansible-tower-setup... folder
1. edit the inventory with 
   - add host under [tower]
   - update admin_password=''
   - update pg_password=''
1. run the setup script
1. go to https://<hostname> redirects to 443
1. attach subscription
1. can change admin password

```
# tar -xvf ansible-tower-setup-latest.tar.gz 
# cd ansible-tower-setup-3.8.1-1/
# ./setup.sh
# firefox https://<hostname>
# awx-manage changepassword admin
```

![image](images/tower-gui.png)
