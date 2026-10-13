#ino
02:42:31:b0:31:00
#kusakabe
 02:42:38:01:2b:00
#kugisaki
02:42:d7:1d:92:00
#miwa
 02:42:0a:45:28:00

#tengen
nano /etc/dhcp/dhcpd.conf
# Kelas Short Lease untuk ino & kusakabe
class "ShortLease" {
    match hardware;
}
subclass "ShortLease" 1:02:42:31:b0:31:00;
subclass "ShortLease" 1:02:42:38:01:2b:00;

# Kelas Long Lease untuk miwa
class "LongLease" {
    match hardware;
}
subclass "LongLease" 1:02:42:0a:45:28:00;

# Deklarasi Subnet Network 3 dengan Lease dan Options Khusus
subnet 10.87.3.0 netmask 255.255.255.0 {
    option routers 10.87.3.1;
    option domain-name-servers 10.87.1.2, 10.87.1.3;
    option domain-search "K47.com";

    # Pool Short Lease (Durasi 30 menit / 1800 detik)
    pool {
        allow members of "ShortLease";
        range 10.87.3.10 10.87.3.89;
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Pool Long Lease (Durasi 12 jam / 43200 detik)[cite: 21]
    pool {
        allow members of "LongLease";
        range 10.87.3.100 10.87.3.199;
        default-lease-time 43200;
        max-lease-time 43200;
    }
}

service isc-dhcp-server restart
service isc-dhcp-server status

restart all nodes

#tengen
cat /var/lib/dhcp/dhcpd.leases
#cek start and end, 30 menit (ino kusakabe), 12 jam (miwa)