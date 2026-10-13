#tengen

#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Instal DHCP server tanpa prompt
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y isc-dhcp-server

chmod +x /root/setup.sh)
/root/setup.sh

nano /etc/dhcp/dhcpd.conf
#tambahin
# Deklarasi Network 4 (Subnet Lokal) tanpa pool dinamis
subnet 10.87.4.0 netmask 255.255.255.0 {
}

# Scope DHCP untuk Network 2
subnet 10.87.2.0 netmask 255.255.255.0 {
    range 10.87.2.100 10.87.2.200;
    option routers 10.87.2.1;
    option domain-name-servers 192.168.122.1;
}

# Scope DHCP untuk Network 3
subnet 10.87.3.0 netmask 255.255.255.0 {
    range 10.87.3.100 10.87.3.200;
    option routers 10.87.3.1;
    option domain-name-servers 192.168.122.1;
}

nano /etc/default/isc-dhcp-server
# add eth 0 ke INTERNETV4
service isc-dhcp-server restart
service isc-dhcp-server status

