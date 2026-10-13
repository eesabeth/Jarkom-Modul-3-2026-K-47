#tengen
nano /etc/dhcp/dhcpd.conf
# Konfigurasi Static Lease untuk Kugisaki (VIP)
host kugisaki {
    hardware ethernet 02:42:d7:1d:92:00;
    fixed-address 10.87.3.99;
}
service isc-dhcp-server restart
service isc-dhcp-server status

restart
ip a