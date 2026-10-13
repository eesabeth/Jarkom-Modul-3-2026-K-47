#tengen
update-rc.d isc-dhcp-server defaults
update-rc.d isc-dhcp-server enable

#jichi
update-rc.d isc-dhcp-relay defaults
update-rc.d isc-dhcp-relay enable

restart

#tengen
rm /var/run/dhcpd.pid
service isc-dhcp-server start
service isc-dhcp-server status

#jichi
service isc-dhcp-relay status
nano /etc/default/isc-dhcp-relay
SERVERS="10.87.4.10"
INTERFACES=""
OPTIONS=""


ip addr add 10.87.4.1/24 dev eth4
ip addr add 10.87.2.1/24 dev eth2
ip addr add 10.87.3.1/24 dev eth3
service isc-dhcp-relay restart

udhcpc -i eth0 -n
ping 10.87.4.10
ping 10.87.3.99 #dll

cat /var/lib/dhcp/dhcpd.leases