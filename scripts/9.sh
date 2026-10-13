#jichi
service isc-dhcp-relay stop
#ino
udhcpc -i eth0 -n

#jichi
service isc-dhcp-relay start
#ino
udhcpc -i eth0 -n