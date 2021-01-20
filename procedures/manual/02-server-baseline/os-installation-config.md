# RHEL 8.x OS install

## pick your poison for installation
I used usb with rhel.iso created with balenaetcher

## installation via GUI for host

### localization
1. keyboard
1. language
1. time and date

### software
1. installation source: red hat cdn
1. software selection: server with gui

### system
1. installation destination: see manual partitions below
1. connected to red hat: added rh account
1. kdump: 
1. network and hostname: enabled network connection eno1. nothing further.
1. security policy: no profile

### manual partitions
[manual partition](
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/performing_an_advanced_rhel_installation/index/#recommended-partitioning-scheme_partitioning-reference)

|mount point|capacity|device type|volme group|filesystem|note|
|-|-|-|-|-|-|
|/(root)|20 GiB	| LVM	| rhel |	xfs|MUST be on separate partition LVM	contains root filesystem|
|/boot | 1024MiB	| Standard Partition	| -|xfs| MUST be on separate partition LVM	contains OS kernel for boot|
|/boot/efi	| 600MiB	|	Standard Partition |-|	EFI| MUST be on separate partition|
|/home	| 50GiB	| LVM	| rhel	| xfs|store user data|
|Swap	| 4GiB |	LVM	| rhel |	swap|

## begin installation

### set root password

### create user account with admin

## reboot

## change boot order from usb to os in bios

## accept EULA