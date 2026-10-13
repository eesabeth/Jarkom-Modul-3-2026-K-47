#jichi
apt-get update
apt-get install -y isc-dhcp-relay

nano /etc/default/isc-dhcp-relay
SERVERS="10.87.4.10"
INTERFACES="eth2 eth3 eth4"
OPTIONS=""

service isc-dhcp-relay restart
service isc-dhcp-relay status

ps aux | grep dhcrelay #cek running atau ga

#itadori
dhclient -v eth0
ip a