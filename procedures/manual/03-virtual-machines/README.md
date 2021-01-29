# From Cockpit UI

## Create Storage
1. go to `Storage` menu tab
1. click and verify partition /dev/nvmen0p4
1. click abd verify volume group /dev/vmstore
1. click `create new logical volume`
   1. name = ansible_lvm
   1. purpose = Block device for filesystems
   1. size = 100GiB
1. go to `Virtual Machines` menu tab
1. go to `Storage Pools` 
1. click `Create Storage Pool`
   1. connection = `System`
   1. name = `Tower`
   1. type = `Filesystem Directory`
   1. target path = `/mnt/tower`
   1. select start pool when host boots
1. click the `tower` pool name
1. click ` storage volumes`
   1. click `activate'
   1. click `create volume`
   1. name = `ansible_vol`
   1. size = `75 GiB`
   1. format = `qcow2`

## Create VM
1. name = `tower`
1. connection = `system`
1. installation type = `local install media`
1. operating system = `rhel 8.2...`
1. storage = `tower` storage pool
1. volume  = `ansible_vol`
1. memory = 4 GiB
1. select immediately start vm

# Command Line

## Create network bridge
1. create bridge interface `bridge0`
1. set bridge slave interface between physical device eno1 (the slave) and bridge connection `bridge0`
1. check status and names of interfaces to add to bridge
1. assign interfaces `eno1` to bridge `bridge0`
1. configure `bridge0` connection
1. configure SPT priority
1. enable autoconnection for `bridge0`
1. enable autoconnection for `bridge0` slaves 
1. up the connection
```
# nmcli connection add type bridge con-name bridge0 ifname bridge0
# nmcli con add type bridge-slave ifname eno1 master bridge0
# nmcli dev 
# nmcli con mod eno1 master bridge0
# nmcli con mod bridge0 ipv4.addresses '192.168.10.2/24'
# nmcli con mod bridge0 ipv4.gateway '192.168.10.1'
# nmcli con mod bridge0 ipv4.dns '208.67.222.222,208.67.220.220'
# nmcli con mod bridge0 ipv4.dns-search 'workbench.lab'
# nmcli con mod bridge0 ipv4.method manual
# nmcli con mod bridge0 bridge.priority '16384'
# nmcli con mod bridge0 connection.autoconnect 1
# nmcli con mod bridge0 connection.autoconnect-slaves 1
# nmcli con up bridge0
# ping 192.168.10.1
```

> [Reference](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking#configuring-a-network-bridge-using-nmcli-commands_configuring-a-network-bridge)


> [Reference](https://www.techotopia.com/index.php/Creating_a_RHEL_KVM_Networked_Bridge_Interface#:~:text=By%20default%2C%20the%20KVM%20virtualization,which%20virtual%20machines%20may%20connect.&text=Network%20bridges%20may%20be%20configured,via%20the%20Cockpit%20web%20interface) 

## Add the KVM network config
Before the bridge can be used by a virtual machine it must be declared and added to the KVM network configuration.

1. create the bridge xml
1. define a new network configuration for bridge0
1. start bridge0
1. autostart bridge0
1. verify virtual networks
1. change from the default virtual network, locate the <interface> section 

```
# vim bridge.xml

<network>
  <name>br0</name>
  <forward mode="bridge"/>
  <bridge name="bridge0" />
</network>

# virsh net-define bridge.xml
# virsh net-start bridge0
# virsh net-autostart bridge0
# virsh net-list --all
# virsh edit tower
> change interface to bridge0
```

(Reference)[https://www.techotopia.com/index.php/Creating_a_RHEL_KVM_Networked_Bridge_Interface]

## Create LVM-base Storage for VM
1. create partition `/dev/nvme0n1p4` (if not created)
1. create physical volume `/dev/nvme0n1p4`
1. create volume group `vmstore`
1. create local mount point `/mnt/tower`
1. create xml for pool definition (POOL DEFINITION NEEDS TESTING)
1. define the pool
1. list the pools
1. start the pool
1. autostart the pool
1. create the vol
1. list the vols

```
# parted 
  > print
  > mkpart 
  > name 
  > format 
  > start 
  > end
  > print 
  > quit
# pvcreate /dev/nvme0n1p4
# vgcreate -n vmstore /dev/nvme0n1p4
# mkdir /mnt/tower
# vim pool.xml
Write the xml
<pool type='logical'>
  <name>guest_images_lvm</name>
  <source>
    <device path='/dev/nvme0n1p4/vmstore'/>
    <name>ansible_vol</name>
    <format type='dir'/>
  </source>
  <target>
    <path>/mnt/tower</path>
  </target>
</pool>
# virsh pool-define pool.xml
# virsh pool-list --all
# virsh pool-start <pool_name>
# virsh pool-autostart <pool_name>
# virsh vol-create-as <pool_name> <vol_name> 50G
# virsh vol-list <pool_name>
```

### Remote storage
Just in case

1. Remove storage
1. Remove logical volume
1. Remove volume group
1. Remove physical volume

```
# virsh vol-undefine
# virsh pool-delete
# virsh pool-undefine
# lvremove /dev/mapper/
# vgremove vgname
# pvremove
# parted
> rm
```

## Create a tower vm
```
# virt-install \ 
--name tower \                         # name of the guest instance
--memory 4096 \                        # RAM allocation
--vcpus 2 \                            # number of vcpus
--disk path=/dev/vmstore/ansible_lv    # mount storage
--os-variant rhel8.0 \                 # osinfo-query os
--cdrom /tmp/rhel-8....iso             # installation media
--network bridge=bridge0 \             # configure to external access
--extra-args --extra-args "ip=192.168.10.40::192.168.10.1:255.255.255.0
```

## Connect to vm
```
# virsh autostart
# virt-viewer tower
```

### Remove a vm
```
# virsh undefine node1 --remove-all-stoarge --nvram
```
