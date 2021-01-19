# Configure post-install

The configurations below follow the RHEL 8 CONFIGURING BASIC SYSTEM SETTINGS found here: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index

## set hostname
```
# hostnamectl status
# hostnamectl set-hostname node00
```

## set network connection
```
# nmcli dev
# nmcli con
# nmcli con add con-name “eno1” ifname “eno1” type ethernet ipv4.method manual ipv4.addresses 192.168.86.240 ipv4.gateway 192.186.68.1 ipv4.dns “208.67.222.222,208.67.220.220” connection.autoconnect true
# nmcli con reload
```

## set /etc/resolv
```
# cat /etc/resolv.conf
 	> nameserver 208.67.222.222
 	> nameserver 208.67.220.220
# systemctl reload networkmanager
# nslookup google.com
```

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

## set subscription manager
When auto-attaching a system, the subscription service checks if the system is physical or virtual, as well as how many sockets are on the system. 

```
# subscription-manager register --username [username] --password [password]
# subscription-manager role --set="Red Hat Enterprise Linux Server"
# subscription-manager service-level --set="Self-Support"
# subscription-manager usage --set="Development/Test"
# subscription-manager attach
```

## set system purpose
System Purpose ensures that the entitlement server auto-attaches the most appropriate subscription to your system. 

```
# syspurpose set-role "Red Hat Enterprise Linux Server"
# syspurpose set-sla "Standard"
# syspurpose set-usage "Production"
# syspurpose show
```

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

## enable cockpit
```
# systemctl enable --now cockpit.socket
# systemctl start cockpit
# firewall-cmd --add-service=cockpit --permanent
# firewall-cmd --reload
# firefox --new-window https://localhost:9090 
```

## enable insights
```
# insights-client --register
# insights-client --status
# cat /etc/insights-client/insights-client.conf
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

## generate SSH keys

## configure users
1. Review user and group ide config 
1. Start new users at 5000 by default
1. Review groups

```
# cat /usr/share/doc/setup*
# vim /etc/login.defs
> UID_MIN
# cat /etc/groups
```

## configure virtualization
```
# yum module install virt
# yum install virt-install virt-viewer libvirt-nss libvirt-daemon-config-network
# systemctl start libvirtd
# virt-host-validate
```

## Create Bridge for external access to VMs
Bridged mode is required to configure externally visible vms 
Review the ip config of the ethernet interface
1. Create a bridge connection for eno1
1. Review the interfaces
1. A bridge slave interface needs to be established between physical device eno1 (slave) and bridge0 connection (master)
1. DOWN the eno1 connection
1. UP the bridge0 connection
1. Ping tests should work (if bridge-slave-eno1 is up)
Bridge connection is active, but not visible to KVM
1. Write bridge file for KVM network configuration
1. Use file to define the new network
1. Start the new bridge0 network
1. List networks 
```
# nmcli con add type bridge con-name bridge0 ifname bridge0 ipv4.address 192.168.86.240 ipv4.gateway 192.168.86.1 ipv4.dns ‘208.67.222.222,208.67.220.220’ ipv4.method manual
# nmcli dev
# nmcli con add type bridge-slave ifname eno1 master bridge0
# nmcli con down eno1
# nmcli con up bridge0
# virsh net-list --all 
# vim /tmp/bridge0.xml
<network>
  <name>bridge0</name>
  <forward mode=”bridge” />
  <bridge name=”bridge0” />
</network>
# virsh net-define /tmp/bridge0.xml
# virsh net-start bridge0
# virsh net-autostart bridge0
# virsh net-list --all
```

## Create LVM Partitions 
# parted
> print
> mkpart > name > format > start > end
> print > quit

## Create Logical Volume against remaining storage
1. understand remaining storage (~950GB remaining)
1. create partition
1. create physical volume
1. create logical volume
```
# lsblk
# pvcreate /dev/nvme0n1p#
# vgcreate node#vg /dev/nvme0n1p#
# mkdir /mnt/node#
# mount /dev/mapper/node1vg-node1lv /mnt/node1
# df -h
# umount /mnt/node1
```
