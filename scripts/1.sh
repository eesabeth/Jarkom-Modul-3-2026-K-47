#jichi
echo "nameserver 192.168.122.1" > /etc/resolv.conf

/root/setup.sh

#client network 1
auto eth0
iface eth0 inet static
    address 10.87.1.2
    netmask 255.255.255.0
    gateway 10.87.1.1

#client network 4
auto eth0
iface eth0 inet static
    address 10.87.1.2
    netmask 255.255.255.0
    gateway 10.87.1.1

#client network 2
auto eth0
iface eth0 inet dhcp

#client network 3
auto eth0
iface eth0 inet dhcp

#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
echo "nameserver 192.168.122.1" > /etc/resolv.conf

#jichi
#!/bin/bash

echo "nameserver 192.168.122.1" > /etc/resolv.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

ip addr add 10.87.1.1/24 dev eth1
ip addr add 10.87.2.1/24 dev eth2
ip addr add 10.87.3.1/24 dev eth3
ip addr add 10.87.4.1/24 dev eth4

ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
ip link set eth4 up