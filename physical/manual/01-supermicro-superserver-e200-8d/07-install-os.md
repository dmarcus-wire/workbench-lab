# Boot Installation
source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#booting-the-installer_getting-started
After you have created bootable media you are ready to boot the Red Hat Enterprise Linux installation.

source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#graphical-installation_graphical-installation

**Other configuration items will be set via Ansible.**

**Enable Ethernet (eno1)**
source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#network-hostname_configuring-system-settings
Turn on Port 1 Network (eno1)

**Configuring software selection**
> this sets DHCP (note the IP Address) and hostname = localhost.localdomain
source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#configuring-software-selection_configuring-software-settings
Server with GUI

**Installation Destination: Custom / Manual Partition**
source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#manual-partitioning_graphical-installation
|Mount Point|Desired Capacity|Device Type|File System|Volume Group|name|Device|
|---|---|---|---|---|---|---|---|
|/(root)|10 GiB|LVM|xfs|rhel|rhel-root|Samsung SSD Pro 970 1TB (nvme0n1)|
|/boot|1 GiB PART|Standard Partition|xfs|-|-|Samsung SSD Pro 970 1TB (nvme0n1)|
|/boot/efi|600 MiB|Standard Partition|EFI System Partition|-|-|Samsung SSD Pro 970 1TB (nvme0n1)|
|/home|50 GiB|LVM|xfs|rhel|rhel-home|Samsung SSD Pro 970 1TB (nvme0n1)|
|swap|4 GiB|LVM|swap|rhel|rhel-swap|Samsung SSD Pro 970 1TB (nvme0n1)|

**Configure root Password**
source: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_a_standard_rhel_installation/index#configuring-a-root-password_graphical-installation