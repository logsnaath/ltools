
cd $(dirname $0)
zypper -n in -y wireshark

ldd /usr/bin/tshark|grep libcares

tshark -D

tshark -c 5 -i eth0 -i lo

tshark -c 5 -i eth0 -F pcapng -w f1.pcapng

file f1.pcapng
