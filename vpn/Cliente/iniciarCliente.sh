
# $1 -> ip del servidor
# $2 -> puerto del servidor

# $3 -> ip del cliente
# $4 -> mascara


openvpn --config ./cliente.conf --remote $1 --port $2 --ifconfig $3 $4
