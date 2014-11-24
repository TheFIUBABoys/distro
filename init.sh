#!/bin/bash

#parametros a recibir por el script :: quien queres ser, y por que interfaz salir, que lo obtiene de arafue supuestamente

#mascaras genericas
MASK_24="255.255.255.0"
MASK_25="255.255.255.128"
MASK_26="255.255.255.192"
MASK_27="255.255.255.224"
MASK_28="255.255.255.240"
MASK_29="255.255.255.248"
MASK_30="255.255.255.252"

#redes que tenemos
RED_A="10.24.1.0" #/24
RED_B="10.24.3.0" #/24
RED_C="10.92.27.104" #/30
RED_D="10.92.27.32" #/27
RED_E="10.24.1.128" #/25
RED_F="10.92.27.64" #/28
RED_G="10.92.27.108" #/30
RED_H="10.92.27.128" #/26
RED_I="10.92.27.0" #/27
RED_J="10.92.27.96" #/29
RED_K="10.92.27.80" #/28
RED_L="192.168.8.0" #/24

RED_M="172.43.0.64" #/30
RED_N="172.43.0.68" #/30
RED_O="172.43.0.72" #/30
RED_P="172.43.0.76" #/30
RED_Q="172.43.0.80" #/30
RED_R="172.43.0.84" #/30
RED_S="10.10.5.0" #/27

# IP HOST A
IP_A="10.24.1.5"
BROADCAST_A="10.24.1.255"
MASCARA_A="255.255.255.0"

# IP HOST B
IP_B="10.92.27.131"
BROADCAST_B="10.92.27.255"
MASCARA_B="255.255.255.192"

# IP HOST C
IP_C="10.24.3.8"
BROADCAST_C="10.24.3.255"
MASCARA_C="255.255.255.0"


# DIRECCION IP SERVIDOR WEB
IP_WEB="192.168.8.8"
BROADCAST_WEB="192.168.8.255"
MASCARA_WEB="255.255.255.0"

# DIRECCIONES IP SERVIDOR TELNET
IP_TELSERVER_E="10.24.1.133"
BROADCAST_TELNETE="10.24.1.255"
MASCARA_TELNETE="255.255.255.128"
IP_TELSERVER_S="10.10.5.8"
BROADCAST_TELNETS="10.10.5.31"
MASCARA_TELNETS="255.255.255.224"

# DIRECCION IP SERVIDOR FTP
IP_FTP="10.92.27.40"
BROADCAST_FTP="10.92.27.63"
MASCARA_FTP="255.255.255.224"

# DIRECCIONES VRRP
IP_VRRP_A="10.24.1.6"
IP_VRRP_B="10.24.3.5"
IP_VRRP_H="10.92.27.132"
IP_VRRP_L="192.168.8.4"


function verificar_dependencia_e_instalar {
	paquete=$1
	INSTALADO=`dpkg -s $paquete | grep -i "Status: install ok installed" | wc -l`
	if [ "$INSTALADO" -ne "1" ]; then
		echo " * El paquete $paquete no se encuentra instalado."
		echo "Instalando paquete $paquete ..."
		apt-get install -y --force-yes $paquete
	else
		echo " * El paquete $paquete esta instalado correctamente."
	fi
}


function validate_apache2 {
	echo "Verificando que apache2 este instalado..."
	if [ -f /etc/init.d/apache2 ]; then
		echo "Apache2 instalado!"
		return 1
	else
		echo "Error: Apache2 no esta instalado!"
		return 0
	fi
}

function validate_ftp {
	echo "Verificando que el server FTP este instalado..."
	if [ -f /etc/init.d/vsftpd ]; then
		echo "Server FTP instalado!"
	    return 1
	else
		echo "Error: Server FTP no esta instalado!"
		return 0
	fi
}

# Esta funcion chequea que este el programa telnetd instalado
# En las compus del laboratorio esta /usr/sbin/in.telnetd y el proceso /etc/init.d/inetd restart
function validate_telnetd {
	echo "Verificando que telnetd este instalado..."
	if [ -f /etc/init.d/openbsd-inetd ]; then
	#if [ -f /etc/init.d/inetd ]; then
		echo "telnetd instalado!"
	    return 1
    else
		echo "Error: telnetd no esta instalado!"
		return 0
    fi
}


#Configurar los hosts
function HOSTA {

	#CONFIGURACION INTERFACES
	ifconfig $interfaz $IP_A broadcast $BROADCAST_A netmask $MASCARA_A
	#RUTEO ESTATICO
	route add -net $RED_B netmask $MASK_24 gw $IP_VRRP_A dev $interfaz
	route add -net $RED_C netmask $MASK_30 gw $IP_VRRP_A dev $interfaz
	route add -net $RED_D netmask $MASK_27 gw $IP_VRRP_A dev $interfaz
	route add -net $RED_E netmask $MASK_25 gw $IP_VRRP_A dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw $IP_VRRP_A dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_H netmask $MASK_26 gw "10.24.1.1" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "10.24.1.1" dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw "10.24.1.1" dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw "10.24.1.1" dev $interfaz
	route add -net $RED_L netmask $MASK_24 gw "10.24.1.1" dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_N netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_O netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_P netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_Q netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_R netmask $MASK_30 gw "10.24.1.1" dev $interfaz
	route add -net $RED_S netmask $MASK_27 gw "10.24.1.1" dev $interfaz

}

function HOSTB {
	#CONFIGURACION INTERFACES
	ifconfig $interfaz $IP_B broadcast $BROADCAST_B netmask $MASCARA_B

	#RUTEO ESTATICO
	route add -net $RED_A netmask $MASK_25 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_B netmask $MASK_24 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_C netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_D netmask $MASK_27 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_E netmask $MASK_25 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_L netmask $MASK_24 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_N netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_O netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_P netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_Q netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_R netmask $MASK_30 gw $IP_VRRP_H dev $interfaz
	route add -net $RED_S netmask $MASK_27 gw $IP_VRRP_H dev $interfaz


}

function HOSTC {
	#CONFIGURACION INTERFACES
	ifconfig $interfaz $IP_C broadcast $BROADCAST_C netmask $MASCARA_C

	#RUTEO ESTATICO
	route add -net $RED_A netmask $MASK_25 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_C netmask $MASK_30 gw "10.24.3.3" dev $interfaz
	route add -net $RED_D netmask $MASK_27 gw "10.24.3.3" dev $interfaz
	route add -net $RED_E netmask $MASK_25 gw "10.24.3.3" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "10.24.3.3" dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw "10.24.3.3" dev $interfaz
	route add -net $RED_H netmask $MASK_26 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_L netmask $MASK_24 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_N netmask $MASK_30 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_O netmask $MASK_30 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_P netmask $MASK_30 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_Q netmask $MASK_30 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_R netmask $MASK_30 gw $IP_VRRP_B dev $interfaz
	route add -net $RED_S netmask $MASK_27 gw "10.24.3.3" dev $interfaz


}


#Configurar los servers
function WEBSERVER {

	#CONFIGURACION INTERFACES
	ifconfig $interfaz $IP_WEB broadcast $BROADCAST_WEB netmask $MASCARA_WEB 

	#RUTEO ESTATICO

	route add -net $RED_A netmask $MASK_25 gw "192.168.8.1" dev $interfaz	
	route add -net $RED_B netmask $MASK_24 gw "192.168.8.1" dev $interfaz
	route add -net $RED_C netmask $MASK_30 gw "192.168.8.1" dev $interfaz
	route add -net $RED_D netmask $MASK_27 gw "192.168.8.1" dev $interfaz
	route add -net $RED_E netmask $MASK_25 gw "192.168.8.1" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "192.168.8.1" dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw "192.168.8.1" dev $interfaz
	route add -net $RED_H netmask $MASK_26 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_N netmask $MASK_30 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_O netmask $MASK_30 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_P netmask $MASK_30 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_Q netmask $MASK_30 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_R netmask $MASK_30 gw $IP_VRRP_L dev $interfaz
	route add -net $RED_S netmask $MASK_27 gw "192.168.8.1" dev $interfaz
}

function FTPSERVER {
	#CONFIGURACION INTERFACES
	ifconfig $interfaz $IP_FTP broadcast $BROADCAST_FTP netmask $MASCARA_FTP
	#RUTEO ESTATICO

	route add -net $RED_A netmask $MASK_25 gw "10.92.27.33" dev $interfaz
	route add -net $RED_B netmask $MASK_24 gw "10.92.27.33" dev $interfaz
	route add -net $RED_C netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_E netmask $MASK_25 gw "10.92.27.33" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "10.92.27.35" dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_H netmask $MASK_26 gw "10.92.27.33" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "10.92.27.33" dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw "10.92.27.33" dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw "10.92.27.33" dev $interfaz
	route add -net $RED_L netmask $MASK_24 gw "10.92.27.33" dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_N netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_O netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_P netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_Q netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_R netmask $MASK_30 gw "10.92.27.33" dev $interfaz
	route add -net $RED_S netmask $MASK_27 gw "10.92.27.33" dev $interfaz

	validate_ftp
	if [ $? -eq 1 ]; then
		echo "FTP..."
		#cp ./servers/ftp/vsftpd.conf /etc/vsftpd.conf
		/etc/init.d/vsftpd start
		echo "Bien."
	else
		echo "Mal."
	fi
}

function TELSERVER {
	interfazE="tap4"
	interfazS="tap5"
	ifconfig $interfazE $IP_TELSERVER_E broadcast $BROADCAST_TELNETE netmask $MASCARA_TELNETE
	ifconfig $interfazS $IP_TELSERVER_S broadcast $BROADCAST_TELNETS netmask $MASCARA_TELNETS

	echo $interfazE
	echo $interfazS

	echo 3 table1 >> /etc/iproute2/rt_tables
	echo 2 table2 >> /etc/iproute2/rt_tables
	ip route add $RED_A/25 via 10.24.1.130 table table1
	ip route add $RED_A/25 via 10.10.5.3 table table2	
	ip route add $RED_B/24 via 10.24.1.130 table table1
	ip route add $RED_B/24 via 10.10.5.2 table table2	
	ip route add $RED_C/30 via 10.24.1.130 table table1
	ip route add $RED_C/30 via 10.10.5.2 table table2	
	ip route add $RED_D/27 via 10.24.1.131 table table1
	ip route add $RED_D/27 via 10.10.5.2 table table2	
	ip route add $RED_E/25 dev tap4 table table1
	ip route add $RED_E/25 via 10.10.5.2 table table2
	ip route add $RED_F/28 via 10.24.1.132 table table1
	ip route add $RED_F/28 via 10.10.5.2 table table2	
	ip route add $RED_G/30 via 10.24.1.132 table table1
	ip route add $RED_G/30 via 10.10.5.2 table table2	
	ip route add $RED_H/26 via 10.24.1.132 table table1
	ip route add $RED_H/26 via 10.10.5.2 table table2	
	ip route add $RED_I/27 via 10.24.1.132 table table1
	ip route add $RED_I/27 via 10.10.5.2 table table2	
	ip route add $RED_J/29 via 10.24.1.132 table table1
	ip route add $RED_J/29 via 10.10.5.2 table table2	
	ip route add $RED_K/28 via 10.24.1.132 table table1
	ip route add $RED_K/28 via 10.10.5.2 table table2	
	ip route add $RED_L/24 via 10.24.1.132 table table1
	ip route add $RED_L/24 via 10.10.5.2 table table2	
	ip route add $RED_M/30 via 10.24.1.132 table table1
	ip route add $RED_M/30 via 10.10.5.2 table table2	
	ip route add $RED_N/30 via 10.24.1.132 table table1
	ip route add $RED_N/30 via 10.10.5.2 table table2	
	ip route add $RED_O/30 via 10.24.1.132 table table1
	ip route add $RED_O/30 via 10.10.5.2 table table2	
	ip route add $RED_P/30 via 10.24.1.132 table table1
	ip route add $RED_P/30 via 10.10.5.2 table table2	
	ip route add $RED_Q/30 via 10.24.1.132 table table1
	ip route add $RED_Q/30 via 10.10.5.2 table table2	
	ip route add $RED_R/30 via 10.24.1.132 table table1
	ip route add $RED_R/30 via 10.10.5.2 table table2	
	ip route add $RED_S/27 via 10.24.1.132 table table1
	ip route add $RED_S/27 dev tap5 table table2

	ip rule flush

	ip rule add table main prio 32766
	ip rule add table default prio 32767

	ip rule add from 10.10.5.8 lookup table2 prio 1001
	ip rule add to 10.10.5.8 lookup table2 prio 1002
	ip rule add from 10.24.1.133 lookup table1 prio 1003
	ip rule add to 10.24.1.133 lookup table1 prio 1004

	ip rule add table table1 prio 1101
	ip rule add table table2 prio 1102


	
	validate_telnetd
	if [ $? -eq 1 ]; then
		echo "Telnet..."
		cp ./servers/telnet/inetd.conf /etc/inetd.conf
		/etc/init.d/inetd restart
		
		echo "Bien."
	else
		echo "Mal"
	fi
}


##### MAIN ######



#Deshabilitar el forward porque los hosts no redireccionan paquetes.
function no_forward {
	echo "Deshabilitando el forwarding..."
	sysctl -w net.ipv4.ip_forward=0  > /dev/null
	RESPU=$(cat /proc/sys/net/ipv4/ip_forward)
	if [ $RESPU -eq 0 ]; then
		echo "Forwarding de add -net $shabilitado."
	else
	echo "No se pudo deshabilitar el forwarding!!!."
	fi
}


interfaz=$2

if [ $1 = "HOSTA" ]; then
	echo "HOSTA"
	echo "Configurando..."
	HOSTA
	echo "Listo."
	no_forward
	exit 0
fi

if [ $1 = "HOSTB" ]; then
	echo "HOSTB"
	echo "Configurando..."
	HOSTB
	echo "Listo."
	no_forward
	exit 0
fi

if [ $1 = "HOSTC" ]; then
	echo "HOSTC"
	echo "Configurando..."
	HOSTC
   	echo "Listo."
	no_forward
	exit 0
fi

if [ $1 = "WEBSERVER" ]; then
	echo "WEBSERVER"
	echo "Configurando..."
	WEBSERVER
   	echo "Listo"
	no_forward
	exit 0
fi

if [ $1 = "FTPSERVER" ] ; then
	echo "FTPSERVER"
	echo "Configurando..."
	FTPSERVER
   	echo "Listo."
	no_forward
	exit 0
fi

if [ $1 = "TELSERVER" ]; then
	echo "TELSERVER"

	echo "Configurando..."
	TELSERVER
   	echo "Listo."
	no_forward
	exit 0
fi


echo "Flasheaste." $1
exit 1
