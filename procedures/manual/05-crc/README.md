# CodeReady Containers Setup
Source: https://www.openshift.com/blog/accessing-codeready-containers-on-a-remote-server/

> for explanation of each setup, visit the Source link as the blog has great details

## Download CRC
1. Go to https://cloud.redhat.com/openshift/create
1. Download tar file to /tmp
1. Unpack the tar file
1. Move crc executable in $PATH
1. Download or Copy the pull secret from the URL in step 1
1. Run the `crc setup` command
1. Enter the pull secret
1. increase memory from 9126 to 32768
1. increase cpus from 4 to 8
1. Run the `crc start` command
1. console log in
1. export oc command to PATH
1. oc log in
```
$ cd ~
$ wget /tmp https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz
$ cd crc
$ tar -xf crc-linux-amd64.tar.xz
$ cd crc-linux-amd64/
$ echo $PATH
$ mv crc /usr/local/bin
$ crc setup
$ crc config set cpus 8
$ crc config set memory 32768
$ crc config set enable-cluster-monitoring true
$ crc console
$ crc oc-env
$ export PATH="/home/admin/.crc/bin/oc:$PATH"
$ oc login -u developer -p developer https://api.crc.testing:6443
```

### Remove CRC
1. crc cleanup
-or-
1. yum install -y virt-manager
1. run crc delete
1. remove .crc configuraion folder from initial install dir
1. remove the crc-nic and crc network interface (CAUTION)
1. remove the dnsmasq conf
1. remove the conf.d conf
1. reboot
```
$ crc stop
$ crc cleanup
$ crc delete
$ rm -rf .crc
$ sudo nmcli dev delete crc-nic
$ sudo nmcli dev delete crc
$ sudo rm /etc/NetworkManager/conf.d/crc-nm-dnsmasq.conf
$ sudo rm /etc/NetworkManager/dnsmasq.d/crc.conf
$ virt-manager
> remove the crc instance
$ reboot
```

# Configure Host DNS
1. check ip address for crc
1. verify dnsmasq via /etc/NetworkManager/conf.d/crc-nm-dnsmasq.conf (created during crc setup)
1. verify dnsmasq via /etc/NetworkManager/dnsmasq.d/crc.conf (create during crc setup)

```
$ crc ip
$ cat /etc/NetworkManager/conf.d/crc-nm-dnsmasq.conf
> [main]
> dns=dnsmasq
$ cat /etc/NetworkManager/dnsmasq.d/crc.conf
> server=/crc.testing/192.168.130.11
> server=/apps-crc.testing/192.168.130.11
```

## Configure remote access

### Download packages
1. download packages: policycoreutils-python-utils, haproxy, jq
```
$ sudo dnf -y install haproxy policycoreutils-python-utils
```

### Configure firewall
1. allow inbound connections on variety of ports

```
$ sudo systemctl start firewalld
$ sudo firewall-cmd --add-port=80/tcp --permanent
$ sudo firewall-cmd --add-port=6443/tcp --permanent
$ sudo firewall-cmd --add-port=443/tcp --permanent
$ sudo systemctl restart firewalld
$ sudo semanage port -a -t http_port_t -p tcp 6443
```

### Configure HA Proxy
1. configure HAProxy to fireward traffic to CRC instance
1. record the host ip address
1. record the crc vm ip address

```
$ export SERVER_IP=$(hostname --ip-address)
$ export CRC_IP=$(crc ip)

alternative,
$ export SERVER_IP=<your_host_ip_address>
$ export CRC_IP=<your_crc_vm_ip_address>
```

### Backup the haproxy.cfg
1. create backup of haproxy.cfg

```
$ cd /etc/haproxy
$ sudo cp haproxy.cfg haproxy.cfg.orig
```

### Edit the haproxy.cfg
1. edit the haproxy.cfg and replace content

```
$ sudo  cat /etc/NetworkManager/haproxy.cfg
global
debug

defaults
log global
mode http
timeout connect 0
timeout client 0
timeout server 0

frontend apps
bind SERVER_IP:80
bind SERVER_IP:443
option tcplog
mode tcp
default_backend apps

backend apps
mode tcp
balance roundrobin
option ssl-hello-chk
server webserver1 CRC_IP check

frontend api
bind SERVER_IP:6443
option tcplog
mode tcp
default_backend api

backend api
mode tcp
balance roundrobin
option ssl-hello-chk
server webserver1 CRC_IP:6443 check
```

### Update the SERVER_IP and CRC_IP
1. replace the SERVER_IP and CRC_IP ip address

```
$ sudo sed -i "s/SERVER_IP/$SERVER_IP/g" haproxy.cfg
$ sudo sed -i "s/CRC_IP/$CRC_IP/g" haproxy.cfg
$ sudo systemctl start haproxy
```

# Configure the Client machine(s)
1. install dnsmasq

```
$ sudo yum install dnsmasq -y
```

### Create DNS configuration
1. create /etc/NetworkManager/conf.d/crc-nm-dnsmasq.conf

```
$ sudo cat /etc/NetworkManager/conf.d/crc-nm-dnsmasq.conf
[main]
dns=dnsmasq

```

### Add DNS entries for CRC server
1. create /etc/NetworkManager/dnsmasq.d/crc.conf
```
$ sudo cat /etc/NetworkManager/dnsmasq.d/crc.conf
address=/apps-crc.testing/SERVER_IP
address=/api.crc.testing/SERVER_IP
$ sudo sed -i "s/SERVER_IP/$SERVER_IP/g" /etc/NetworkManager/dnsmasq.d/crc-dns.conf
```

### Update /etc/hosts

```
192.168.130.11 api.crc.testing console-openshift-console.apps-crc.testing default-route-openshift-image-registry.apps-crc.testing oauth-openshift.apps-crc.testing
```

### Update routing table


```
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.10.1    0.0.0.0         UG    425    0        0 bridge0
192.168.10.0    0.0.0.0         255.255.255.0   U     425    0        0 bridge0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
192.168.130.0   0.0.0.0         255.255.255.0   U     0      0        0 crc
```

### Reload NetworkManager
```
$ sudo systemctl reload NetworkManager
```

# Troubleshooting
1. If `Server Not Found`, ensure ssh is allow through firewall
1. If 'Error...domain 'crc' already exists with uuid...', launch virt-manager and remove crc instance
