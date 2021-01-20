## configure virtualization
```
# yum module install virt
# yum install virt-install virt-viewer libvirt-nss libvirt-daemon-config-network
# systemctl start libvirtd
# virt-host-validate
```

## create Bridge for external access to VMs
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

## create partitions and lvm

1. understand remaining storage (~950GB remaining)
1. create partition
1. create physical volume
1. create volume group
1. create logical volume
1. create mount point

```
# parted
> print
> mkpart > name > format > start > end
> print > quit
# lsblk
# pvcreate /dev/nvme0n1p#
# vgcreate node#vg /dev/nvme0n1p#
# mkdir /mnt/node#
# mount /dev/mapper/node1vg-node1lv /mnt/node1
# df -h
# umount /mnt/node1
```
