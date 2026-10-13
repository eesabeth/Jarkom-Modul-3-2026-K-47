#itadori
MAC Address: 02:42:f7:f8:9b:00
#fushiguro
 02:42:ed:4d:25:00
#zenin
 02:42:14:ef:e3:00
#okkotsu
02:42:f5:2a:33:00

#tengen
nano /etc/dhcp/dhcpd.conf
add # ke ip 10.87.2.0
# Deklarasi Kelas untuk Tim Dev (itadori & fushiguro)
class "Dev" {
    match hardware;
}
subclass "Dev" 1:02:42:f7:f8:9b:00;
subclass "Dev" 1:02:42:ed:4d:25:00;

# Deklarasi Kelas untuk Tim Support (zenin & okkotsu)
class "Support" {
    match hardware;
}
subclass "Support" 1:02:42:14:ef:e3:00;
subclass "Support" 1:02:42:f5:2a:33:00;

# Subnet Network 2 dengan pemisahan Pool
subnet 10.87.2.0 netmask 255.255.255.0 {
    option routers 10.87.2.1;
    option domain-name-servers 192.168.122.1;

    # Pool 1 (Dev)
    pool {
        allow members of "Dev";
        range 10.87.2.10 10.87.2.35;
    }

    # Pool 2 (Support)
    pool {
        allow members of "Support";
        range 10.87.2.70 10.87.2.95;
    }
}

service isc-dhcp-server restart
service isc-dhcp-server status

ip addr flush dev eth0
rm -f /var/lib/dhcp/dhclient*.leases
rm -f /var/lib/dhcpc/*.pid

restart node

ip a