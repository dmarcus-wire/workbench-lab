# CodeReady Containers Setup
Source: https://www.openshift.com/blog/accessing-codeready-containers-on-a-remote-server/

> for explanation of each setup, visit the Source link as the blog has great details

## Download CRC
1. Go to https://cloud.redhat.com/openshift/create
1. Download tar file to /tmp
1. Unpack the tar file
1. Move executable in $PATH
1. Download or Copy the pull secret from the URL in step 1
1. Run the `crc setup` command
1. Enter the pull secret
1. Run the `crc start` command

```
$ wget -P /tmp https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz
$ cd /tmp
$ tar -xf crc-linux-amd64.tar.xz
$ cd crc-linux-amd64/
$ echo $PATH
$ mv ./crc /usr/local/bin
$ crc setup
$ crc start
```

# Configure the Host machine
1. Download packages for firewalld and HAProxy to route traffic to CRC

```
$ sudo dnf -y install haproxy policycoreutils-python-utils
```

### Configure the firewall
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

