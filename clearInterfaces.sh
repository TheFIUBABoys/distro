#!/bin/bash

# restauración de configuraciones para la tabla de ruteo
# cleardata
	#Vaciado de tabla de ruteo.
	#`ip route flush all`
	echo "listo flush"
	interfaces=`ifconfig | egrep "eth" | sed 's/^\([A-Za-z0-9:]*\).*/\1/'`
	for iinterfaz in $interfaces
	do
	echo $iinterfaz
	    `ip addr flush $iinterfaz`
	done
	echo "listo interfaces"
#	interfaz=`ifconfig | egrep "eth" | sed 's/^\([A-Za-z0-9:]*\).*/\1/'`
#	dhclient $interfaz
