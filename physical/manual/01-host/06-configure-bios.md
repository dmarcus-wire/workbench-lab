# BIOS
source: https://www.supermicro.com/wftp/utility/SMCIPMITool/Linux/
page: 47

**AMI BIOS setup utility for the X10SDV-6C-TLN4F motherboard**
## BIOS Setup Utility
1. Hit the `<Delete>` key while the system is booting-up.       
    - In most cases, the `<Delete>` key is used to invoke the BIOS setup screen. 
    - There are a few cases when other keys are used, such as `<F1>`, `<F2>`, etc.) Each main BIOS menu option is described in this manual.

## Main BIOS screen has two main frames. 
| | |
|---|---|
|```The left frame displays all the options that can be configured. “Grayed-out” options cannot be configured. The right frame displays the key legend.```|```When an option is selected in the left frame, it is highlighted in white. Often a text message will accompany it.```|

> Note that BIOS has default text messages built in. We retain the option to include, omit, or
change any of these text messages. 
Settings printed in Bold are the default values

**Screens/Tabs are Bolded**
Only changes are documented in table.

## Advanced Tab
### Boot Feature
|Record|Setting|Description|
|---|---|---|
|Power Button Function|[4 seconds override]|Power off the system after pressing and holding the power button for 4 seconds or longer|
|Restore on AC Power Loss|[Stay Off]|Stay-Off for the system power to remain off after a power loss|

## Advanced Tab
### CPU Configuration
|Record|Setting|Description|
|---|---|---|
|Hardware Prefetcher|[Enabled]|Prefetch streams of data and instructions from the main memory to the L2 cache to improve CPU performance|
|DCU Streamer Prefetcher|[Enabled]|Stream and prefetch data and send it to the Level 1 data cache to improve data processing and system performance|
|DCU IP Prefetcher|[Enabled]|Prefetch IP addresses to improve network connectivity and system performance|

## Advanced Tab
### CPU Configuration > Advanced Power Management Configuration > CPU HWPM State Control
|Record|Setting|Description|
|---|---|---|
|Enable CPU HWPM|[HWPM NATIVE MODE]|Better CPU energy performance|

## Advanced Tab
### CPU Configuration > Advanced Power Management Configuration > CPU T State Control
|Record|Setting|Description|
|---|---|---|
|ACPI (Advanced Configuration Power Interface) T-States|[Disable]|Support CPU throttling by the operating system to reduce power consumption|

## Advanced Tab
### Chipset Configuration > North Bridge > Memory Configuration > DIMM Information
|Record|Setting|Description|
|---|---|---|
|DIMMA1|2133T/s Sa..|Should see your Memory sticks|
|DIMMA1|2133T/s Sa..|Should see your Memory sticks|
|DIMMA2|2133T/s Sa..|Should see your Memory sticks|
|DIMMA2|2133T/s Sa..|Should see your Memory sticks|

## Advanced Tab
### PCIe/PCI/PnP Configuration
|Record|Setting|Description|
|---|---|---|
|M.2 PCI-E 3.0 X4 OPROM|[EFI]|Select which firmware type to be loaded for the add-on card in this slot|
|SLOT 7 PCI-E 3.0 X16 OPROM|[EFI]|Select which firmware type to be loaded for the add-on card in this slot|
|Onboard LAN Option ROM Type|[EFI]|Enable Option ROM support to boot the computer using a network device|
|Onboard Video Option ROM|[EFI]|Select the Onboard Video Option ROM type|

## Event Logs
### Change SMBIOS Event Log Settings
|Record|Setting|Description|
|---|---|---|
|PCI-Ex Error Enable|[No]|for the BIOS to correct errors occurred in the PCI-E slots|
|Erase Event Log|[No]|If No is selected, data stored in the event log will not be erased|
|When Log is Full|[Do Nothing]|when the event log memory is full|

## IPMI
### BMC Network Configuration**
|Record|Setting|Description|
|---|---|---|
|IPMI LAN Selection|[Share LAN]|displays the IPMI LAN setting|
|IPMI Network Link Status|No Connect|displays the IPMI Network Link status|
|Configuration Address Source|[DHCP]|If Static is selected, you will need to know the IP address of this computer and enter it to the system manually in the field.|
|Station IP Address|192.168.010.010|the Station IP address for this computer|
|Subnet Mask|255.255.255.000|sub-network that this computer belongs to|
|Gateway IP Address|192.168.010.001|displays the Gateway IP address for this computer.|
|VLAN|[Disable]|Disables IPMI VLAN function|

## Security
|Record|Setting|Description|
|---|---|---|
|Administrator Password| ********** |

## Boot Settings
|Record|Setting|Description|
|---|---|---|
|Setup Prompt Timeout|5|the length of time (the number of seconds) for the BIOS to wait before rebooting the system when the setup activation key is pressed|
|Boot Mode Select|[UEFI]|the type of device that the system is going to boot from|
|Fixed Boot Order Priorities| |[UEFI USB Key] for Installation CHANGE TO [UEFI Hard Disk:Red Hat Enterprise Linux]|
|UEFI Boot Order #2| |[UEFI Hard Disk..] for Installation CHANGE [UEFI USB Key]|
|UEFI Boot Order #3| |[UEFI Network:UEFI: IP4 Intel(R) Ethernet Connection X552/X557-AT 10GBASE-T]|
|UEFI Boot Order #4| |[UEFI AP:UEFI: Built-in EFI Shell]|

## Boot Settings
### UEFI Hard Disk Drive BBS Priorities
|Record|Setting|Description|
|---|---|---|
|Setup Prompt Timeout|5|Number of seconds to wait for activation setup|
|Boot Mode Select|UEFI|Which boot device to list in FIXED BOOT ORDER Priorities|
|UEFI Boot Order #1|[Red Hat Enterprise Linux]|Initial Installation set to [UEFI USB Key:UEFI: GENERIC Flash Disk 8.07]|
|UEFI Boot Order #2|[UEFI Network||

## Boot Settings
### Application Boot Priorities
|Record|Setting|Description|
|---|---|---|
|UEFI Boot Order #1|[UEFI: Built-in EFI Shell]|