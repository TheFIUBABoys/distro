
# $1 -> Ip del servidor

PHISICAL_IP=$1

IP=10.10.5.8
MASK=255.255.255.224
TAP=tap5

openvpn --remote $PHISICAL_IP --port 1199 --dev $TAP --ifconfig $IP $MASK
