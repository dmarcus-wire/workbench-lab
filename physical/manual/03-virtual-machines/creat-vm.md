# Command Line
```
# virt-install \ 
--name nodev00 \ 						# name of the guest instance
--memory 8192 \ 					# 8GB RAM allocation
--vcpus 4 \ 						# 4 number of vcpus
--disk path=/dev/vmstore/nodev00			# mount storage
--os-variant rhel8.0 \ 					# osinfo-query os
--cdrom /tmp/rhel-8....iso 				# installation media
--network bridge=bridge0 \ 				# configure to external access
--extra-args --extra-args "ip=192.168.86.242::192.168.86.1:255.255.255.0:node1.lunchbox.com:eth0:none"
```

# RHEL Web UI