# RHEL 8.x OS post install config

The configurations below follow the RHEL 8 CONFIGURING BASIC SYSTEM SETTINGS found [here](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index).

## set hostname
```
# hostnamectl status
# hostnamectl set-hostname node00
```
> automated with: \
[a-hostname.yml](procedures/automate/02-server-baseline/playbooks/a-hostname.yml)

## set system time
```
# timedatectl set-ntp true
> server 0.north-america.pool.ntp.org
> server 1.north-america.pool.ntp.org
> server 2.north-america.pool.ntp.org
> server 3.north-america.pool.ntp.org
# timedatectl set-timezone America/Denver
# systemctl restart chronyd
# chronyc sources -v
```
> automated with: \
[a-hostname.yml](procedures/automate/02-server-baseline/playbooks/a-hostname.yml)
## set network connection
```
# nmcli dev
# nmcli con
# nmcli con add con-name “eno1” ifname “eno1” type ethernet ipv4.method manual ipv4.addresses 192.168.86.240 ipv4.gateway 192.186.68.1 ipv4.dns “208.67.222.222,208.67.220.220” connection.autoconnect true
# nmcli con reload
```
> automated with: \
[b-network-nmcli.yml](procedures/automate/02-server-baseline/playbooks/b-nmcli-network.yml) \
[b-network-role.yml](procedures/automate/02-server-baseline/playbooks/b-network-role.yml)

## set /etc/resolv
```
# cat /etc/resolv.conf
 	> nameserver 208.67.222.222
 	> nameserver 208.67.220.220
# systemctl reload networkmanager
# nslookup google.com
```
> automated with: \
[b-network-nmcli.yml](procedures/automate/02-server-baseline/playbooks/b-nmcli-network.yml) \
[b-network-role.yml](procedures/automate/02-server-baseline/playbooks/b-network-role.yml)

## set subscription manager
When auto-attaching a system, the subscription service checks if the system is physical or virtual, as well as how many sockets are on the system. 
```
# subscription-manager register --username [username] --password [password]
# subscription-manager role --set="Red Hat Enterprise Linux Server"
# subscription-manager service-level --set="Self-Support"
# subscription-manager usage --set="Development/Test"
# subscription-manager attach
```
> automated with: \
[c-subscription-manager.yml](procedures/automate/02-server-baseline/playbooks/c-subscription-manager.yml)

## set system purpose
System Purpose ensures that the entitlement server auto-attaches the most appropriate subscription to your system. 

```
# syspurpose set-role "Red Hat Enterprise Linux Server"
# syspurpose set-sla "Standard"
# syspurpose set-usage "Production"
# syspurpose show
```
> automated with: \
[c-subscription-manager.yml](procedures/automate/02-server-baseline/playbooks/c-subscription-manager.yml)

## install software
1. ansible dnf-automatic cockpit*
1. container tools

```
# subscription-manager attach --pool=<pool_id>
# subscription-manager repos --enable ansible-2-for-rhel-8-x86_64-rpms
# subscription-manager repos --enable=rhel-7-server-extras-rpms
# subscription-manager repos --enable=rhel-7-server-optional-rpms
# yum install ansible -y
# yum module install container-tools
```
> automated with: \
[c-subscription-manager.yml](procedures/automate/02-server-baseline/playbooks/c-subscription-manager.yml)
[d-yum-update.yml](procedures/automate/02-server-baseline/playbooks/d-yum-update.yml)

## dnf configuration
Install, download and apply updates per /etc/dnf/automatic.conf

```
# vim /etc/dnf/automatic.conf
Apply security updates (same config can also be done in cockpit > software updates > automatic)
> upgrade_type = security
The name of the system
> system_name = <enter-hostname>
On login, messages about updates displayed
> emit_via = motd
# systemctl enable dnf-automatic.timer; systemctl start dnf-automatic.timer
```
> automated with: \
[e-dnf-automatic.yml](procedures/automate/02-server-baseline/playbooks/e-dnf-automatic.yml)

## enable cockpit
```
# systemctl enable --now cockpit.socket
# systemctl start cockpit
# firewall-cmd --add-service=cockpit --permanent
# firewall-cmd --reload
# firefox --new-window https://localhost:9090 
```
> automated with: \
[f-enable-start-services.yml](procedures/automate/02-server-baseline/playbooks/f-enable-start-services.yml)

## enable insights
```
# insights-client --register
# insights-client --status
# cat /etc/insights-client/insights-client.conf
```
> automated with: \
[f-enable-start-services.yml](procedures/automate/02-server-baseline/playbooks/f-enable-start-services.yml)

## sos reports
1. install packages
1. run report
1. Disable plugins from running
1. Review files
/tmp/ or /var/tmp or use --tmp-dir to specify alternate location
1. Upload to case 
1. Upload large files to FTP (-f)
1. Split large files (-s)

```
# yum install sos redhat-support-tool
# sosreport 
# sosreport -n kvm,amd
$ redhat-support-tool addattachment -c CASE_NUMBER /path/to/sosreport
$ redhat-support-tool addattachment -c CASE_NUMBER -f /path/to/sosreport
$ redhat-support-tool addattachment -c CASE_NUMBER -s 1024 -f /path/to/vmcore
```
## secure system

1. Upgrade the latest available packages with security errata
1. Upgrade to last security errata packages
1. Review services to enable/disable
1. If your system has no printers, disable cups, for example
```
# yum update --security
# yum update-minimal --security
# systemctl status firewalld
# systemctl start firewalld; systemctl enable firewalld
# systemctl list-units | grep service
# systemctl mask cups
# getenforce
# cat /etc/selinux/config
```
> automated with: \
[l-secure-host.yml](procedures/automate/02-server-baseline/playbooks/l-secure-host.yml)
## generate SSH keys
1. create a private key and matching public key for authentication
1. public key needs to be copied to the destination system
```
# ssh-keygen
# ssh-copy-id user@host.com (or ip address)
```
> automated with: \
[l-secure-host.yml](procedures/automate/02-server-baseline/playbooks/l-secure-host.yml)
## prohibit the superuser from logging in using ssh
1. OpenSSH server uses the PermitRootLogin configuration setting in the /etc/ssh/sshd_config
1. set PermitRootLogin to no
   - alternatively, prevent password-based authentication but allow private key-based authentication for root, set the PermitRootLogin parameter to without-password
```
# vim /etc/ssh/sshd_config
> PermitRootLogin no
```
> automated with: \
[l-secure-host.yml](procedures/automate/02-server-baseline/playbooks/l-secure-host.yml)
## prohibit password-based authentication for ssh
1. Allow only private key-based logins to the remote command line
   - Attackers cannot use password guessing attacks to remotely break into known accounts on the system.
   - With passphrase-protected private keys, an attacker needs both the passphrase and a copy of the private key. With passwords, an attacker just needs the password.
1. set PasswordAuthentication no to prohibit users to use password-based authentication while logging in
```
# vim /etc/ssh/sshd_config
> PasswordAuthentication yes
```
> automated with: \
[l-secure-host.yml](procedures/automate/02-server-baseline/playbooks/l-secure-host.yml)
## reload sshd service
whenever you change the /etc/ssh/sshd_config file, you must reload the sshd service for changes to take effect

```
# systemctl reload sshd
```
> automated with: \
[l-secure-host.yml](procedures/automate/02-server-baseline/playbooks/l-secure-host.yml)
## set StrictHostKeyChecking
Set the StrictHostKeyChecking parameter to yes in the user-specific ~/.ssh/config file or the system-wide /etc/ssh/ssh_config to cause the ssh command to always abort the SSH connection if the public keys do not match.
