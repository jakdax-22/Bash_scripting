#!/bin/bash
!#/bin/bash

echo "
######################################################
#                                                    #
#           [+] PRECONFIGURACIÓN DEL ROUTER          #    
#                                                    #
######################################################
"

# LEEMOS LA TARJETA DE RED
read -p "[~] TARJETA DE RED A CONFIGURAR DINÁMICAMENTE: " int1

echo "
[+] APLICANDO CONFIGURACIONES...
"

# CONFIGURACIÓN DINÁMICA
dhclient $int1

# ACTIVANDO ENRUTAMIENTO
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "
[+] APLICANDO CONFIGURACIONES PREVIAS A IPTABLES...
"

# BORRAMOS EL FIREWALL
iptables -F

# BORRAMOS LAS CADENAS
iptables -X

# BORRAMOS LA TRADUCCIÓN DE REDES (NAT)
iptables -F -t nat

# BORRAMOS LA CADENA DE TRADUCCIÓN DE REDES (NAT)
iptables -X -t nat

# AÑADIMOS A IPTABLES LA ÓRDEN DE REENVÍO
iptables -t nat -A POSTROUTING -o $int1 -j MASQUERADE

echo "
[+] VISUALIZAMOS LAS REGLAS DE IPTABLES
"

# VISULIZAMOS IPTABLES
iptables -S

echo "
[+] VISUALIZAMOS LAS CONFIGRACIONES DE RED
"

# VISUALIZAMOS LA CONFIGURACIÓN
ip a l

echo "
#####################################################
#                                                   #
#	    [+] CONFIGURACIONES RED LOCAL           #
#                                                   #
#####################################################
"

# LEEMOS LA TARJETA DE RED
 read -p "[~] TARJETA DE RED CON CONFIGURACIÓN ESTÁTICA: " int2

# LEEMOS LA IP
read -p "[~] DIRECCIÓN IP: " ip

# LEEMOS LA MÁSCARA
read -p "[~] MÁSCARA: " masc

# LEEMOS LA PUERTA DE ENLACE
# read -p "[~] DIRECCIÓN DE LA PUERTA DE ENLACE: " router

echo "
APLICANDO CONFIGURACIÓN...
"

# ASIGNAMOS IP/MÁSCARA A LA INTERFAZ 
ip a a $ip/$masc dev $int2

# ASIGNAMOS LA PUERTA DE ENLACE
# ip r a default via $router

# ASIGNAMOS EL NOMBRE DEL SERVIDOR
# echo nameserver $router > /etc/resolve.conf

echo "
#####################################################
#                                                   #
#              [+] CREACIÓN DE VLANS                #
#                                                   #
#####################################################
"

# LEYENDO RESPUESTA
read -p "[~] INSTALAR PAQUETES DE CONFIGURACIÓN [S/N]: " resp1

# CONDICIÓN
if [ $resp1 == 'S' ] || [ $resp1 == 's' ] || [ -z $resp1 ];
then
	echo "INSTALANDO PAQUETES..."
	yum install epel-release.noarch
	yum install vconfig 
fi

read -p "CREAR VLANS:[S/N] " rvlan

if [ $rvlan == 'S' ] || [ $rvlan == 's' ] || [ -z $rvlan ]
then
	# CREACIÓN DE VLANS
	read -p "INDICA EL NÚMERO MÁXIMO DE VLANS: " nvlan

	# BUCLE DE CREACIÓN DE VLANS
	for (( i=1; i<=$nvlan; i++ ))
	do
		# CREACIÓN DE LAS VLANS
		echo "CREANDO VLAN: $i
	============"
		# CONFIGURANDO LAS VLANS
 		vconfig add $int2 $i
		echo "[+] CONFIGURACIÓN DE LA DIRECCIÓN IP"
		# CREACIÓN DE LA IP DE LA VLAN
		read -p "[~] ESCRIBE LA DIRECCIÓN IP: " ipvl
		# CREACIÓN DE LA MÁSCARA DE LA VLAN
		read -p "[~] ESCRIBE LA MÁSCARA: " mascvl
		echo "[+] CONFIGURANDO...
	============"
		# APLICANDO CONFIGURACIÓN
		ip a a $ipvl/$mascvl dev $int2.$i
		# ENCENDIENDO LAS INTERFACES
		read -p "[~] INTERFAZ ENCENDIDA:[S/N] " intup
			
			if [ $intup == 'S' ] || [ $intup == 's' ] || [ -z $intup ];
			then
				echo "[*] ENCENDIENDO LA INTERFAZ DE LA VLAN..."
				ip l s $int2.$i up
			else
				echo "[*] LA INTERFAZ DE LA VLAN PERMANECERÁ APAGADA"
			fi
	done
elif [ $rvlan == 'N' ] || [ $rvlan == 'n' ]
then
	read -p "[~] BORRAR INTERFACES:[S/N] " dvl
		if [ $dvl == 'S' ] || [ $dvl == 's' ];
		then
			read -p "[+] NÚMERO DE LAS VLANS QUE DESEAS BORRAR: " rmvl
			
			for (( i=1; i<=$rmvl; i++ ))
			do
				vconfig rem $int2.$i
			done
		elif [ -z $dvl ]
		then 
			echo "[+] CONFIGURACIÓN FINALIZADA"
		fi
fi

echo "
#####################################################
#                                                   #
#            CONFIGURACIÓN DE IPTABLES              #
#                                                   #
#####################################################
"

echo "
REALIZANDO PRECONFIGURACIÓN
"

iptables -F && iptables -X

# ESTABLECIENDO UNA POLÍTICA POR DEFECTO
read -p "[~] POLÍTICA POR DEFECTO:[ACCEPT/*DROP*/REJECT]: " respipt

# CONDICIONES SEGÚN LO ESTABLECIDO EN LA VARIABLE
if [ $respipt == 'ACCEPT' ] || [ $respipt == 'accept' ] || [ $respipt == 'a' ] || [ $respipt == 'A' ]
then
	echo "[+] APLICANDO CONFIGURACIÓN DE POLÍTICA POR DEFECTO 'ACCEPT'..."
	iptables -P FORWARD ACCEPT
elif [ $respipt == 'DROP' ] || [ [ $respipt == 'drop' ] || [ $respipt == 'd' ] || [ $respipt == 'D' ]
then 
	echo "[+] APLICANDO CONFIGURACIÓN DE POLÍTICA POR DEFECTO 'DROP'..."
	iptables -P FORWARD DROP
elif [ $respipt == 'REJECT' ] || [ $respipt == 'reject' ] || [ $respipt == 'r' ] || [ $respipt == 'R' ]
then
	echo "[+] APLICANOD CONFIGURACIÓN DE POLÍTICA POR DEFECTO 'REJECT'..."
	iptables -P FORWARD REJECT
else
	echo "[+] SE APLICARÁ LA POLÍTICA POR DEFECTO DEL SISTEMA..."
fi

echo "
[+] MOSTRAMOS LAS CONFIGURACIONES DE RED
"
ip a l

echo "
[+] MOSTRAMOS LAS CONFIGURACIONES DE IPTABLES
"
iptables -L

echo "
[+] MOSTRAMOS LA TABLA DE ENRUTAMIENTO
"
ip r l

echo "
#####################################################
#                                                   #
#            PRECONFIGURACIÓN DE IPTABLES           #
#                                                   #
#####################################################
"

echo " REALIZANDO PRECONFIGURACIÓN "
# ELIMINACIÓN DE IPTABLES echo "ELIMINAREMOS LA CONFIGURACIÓN DE IPTABLES CON LOS COMANDOS: iptables -F && iptables -X" 
# iptables -F && iptables -X read pause

# PREGUNTA
read -p "CONFIGURAR POLÍTICA POR DEFECTO:[S/N] " resppd
if [ $resppd -z ];
then
	echo "NO SE HA INDICADO NINGÚN OPERADOR UNARIO. POR LA TANTO LA RESPUESTA ES 'S'"
fi

# CONDICIÓN
if [ $resppd == 'S' ] || [ $resppd == 's' ] || [ -z "$resppd" ]; then

	# ESTABLECIENDO UNA POLÍTICA POR DEFECTO
	read -p "[~] POLÍTICA POR DEFECTO:[ACCEPT/DROP] " respipt
	if [ $respipt -z ];
	then
		echo "NO SE HA INDICADO NINGÚN OPERADOR UNARIO. POR LO TANTO APLICAREMOS LA POLÍTICA POR DEFECTO 'ACCEPT'"
	fi

	# CONDICIONES SEGÚN LO ESTABLECIDO EN LA VARIABLE
	if [ $respipt == 'ACCEPT' ] || [ $respipt == 'accept' ] || [ $respipt == 'a' ] || [ $respipt == 'A' ] || [ $respipt -z ];
	then
		echo "[+] APLICANDO CONFIGURACIÓN DE POLÍTICA POR DEFECTO 'ACCEPT'..."
		iptables -P FORWARD ACCEPT
	elif [ $respipt == 'DROP' ] || [ [ $respipt == 'drop' ] || [ $respipt == 'd' ] || [ $respipt == 'D' ];
	then
		echo "[+] APLICANDO CONFIGURACIÓN DE POLÍTICA POR DEFECTO 'DROP'..."
		iptables -P FORWARD DROP
	else
		echo "[+] SE APLICARÁ LA POLÍTICA POR DEFECTO DEL SISTEMA..."
	fi 
fi

echo " [+] MOSTRAMOS LAS CONFIGURACIONES DE RED "
ip a 
read pause

echo " [+] MOSTRAMOS LAS CONFIGURACIONES DE IPTABLES " 
iptables -L -nv 
read pause

echo " [+] MOSTRAMOS LA TABLA DE ENRUTAMIENTO " 
ip r l 
read pause

echo "
#####################################################
#                                                   #
#	        MASQUERADE/SNAT/DNAT                #
#                                                   #
#####################################################
"

read -p "DESEA CONFIGURAR LA TRADUCCIÓN DE REDES:[S/N] " snnat 
if [ $snnat == 'S' ] || [ $snnat == 's' ] || [ $snnat -z ]; 
then

if [ $snnat -z ];
then
	echo "NO SE HA ENCONTRADO NINGÚN OPERADOR UNARIO. POR LO TANTO APLICAREMOS LA POLÍTICA POR DEFECTO MASQUERADE"
fi
	read -p "ELIJA UNA DE LAS OPCIONES: [MASQUERADE/SNAT/DNAT] " rnat
	if [ $rnat == 'MASQUERADE' ] || [ $rnat == 'masquerade' ] || [ -z "$rnat" ] || [ $rnat == 'm' ] || [ $rnat == 'M' ]
	then
		read -p "POR FAVOR, INDIQUE LA INTERFAZ: " $mint
		iptables -t nat -A POSTROUTING -o $mint -j MASQUERADE
	elif [ $rnat == 'SNAT' ] || [ $rnat == 'snat' ] || [ $rnat == 's' ] || [ $rnat == 'S' ]
	then
		read -p "INDICA LA INTERFAZ: " $sint
		read -p "INDICA EL EQUIPO: " $tint
		iptables -t nat -A POSTROUTING -o $sint -j SNAT --to $tint
	elif [ $rnat == 'DNAT' ] || [ $rnat == 'dnat' ] || [ $rnat == 'd' ] || [ $rnat == 'D' ]
	then
		read -p "INDICA LA INTERFAZ: " $dint
		read -p "INDICA EL EQUIPO: " $deint
		iptables -t nat -A PREROUTING -i $dint -j DNAT --to $deint
	fi
fi

echo "=========================================================================================================================================

#####################################################
#                                                   #
#                    [$]IPTABLES                    #
#                                                   #
#####################################################
"

# REPETIR PREGUNTA Y SALIR SI QUIERES
#
# for (( ; ; )) do
#	read -p "PREGUNTA" resp if [ $resp == 'S' ] then
#		echo "HOLA" else break fi
# done

read -p "
ELIJA UNA OPCIÓN:
AÑADIR(-A)====== [0] 
INSERTAR (-I)====[1] 
ELIMINAR (-D)====[2]
PERSONALIZAR (-N)[5]
RESPUESTA: " pnormar

#COMPROBAR (-C)===[3]
#RENOMBRAR (-E)===[4]

if [ $pnormar == 0 ]; 
then
	pnorma=-A

elif [ $pnormar == 1 ]; 
then
	pnorma=-I
	
read -p "
ELIJA UN OPCIÓN:
INPUT======[0] 
OUTPUT=====[1] 
FORWARD====[2] 
POSTROUTING[3] 
PREROUTING=[4]
PERSONALIZADO[5]
RESPUESTA: " snormar

if [ $snormar == 0 ]; then
        snorma=INPUT

elif [ $snormar == 1 ]; then
        snorma=OUTPUT

elif [ $snormar == 2 ]; then
        snorma=FORWARD

elif [ $snormar == 3 ]; then
        snorma=POSTROUTING

elif [ $snormar == 4 ]; then
        snorma=PREROUTING

elif [ $snormar == 5 ]; then
	read -p "
ESCRIBA EL NOMBRE DE LA CADENA:
RESPUESTA: " snorma
fi

iptables -L -nv --line-numbers

read -p "
ESCRIBA EL NÚMERO DE LA INSERCIÓN
RESPUESTA: " number

read -p "
ELIJA UNA OPCIÓN:
PROTOCOLO====[0] 
ORIGEN=======[1] 
DESTINO======[2] 
MODULO=======[3] 
SALIR========[4]
RESPUESTA: " optionr

if [ $optionr == 0 ];
then
	read -p "
ELIJA UN OPCIÓN:
DIRERENCIADOR============[0] 
SALIR====================[1]
RESPUESTA: " dex
	if [ $dex == 0 ];
	then
		a=!
	elif [ $dex == 1 ];
	then
		echo "
OPCIÓN: SIN DIFERENCIADOR"
	fi
	
	pro=-p
	read -p "
ELIJA UNA OPCIÓN:
TCP======[0] 
UDP======[1]
RESPUESTA: " pror
	if [ $pror == 0 ];
	then
		protocolo=tcp
	elif [ $pror == 1 ];
	then
		protocolo=udp
	fi
	read -p "
ELIJA UNA OPCIÓN: 
PUERTO ORIGEN=============[0] 
PUERTO DESTINO============[1] 
NIGÚN PUERTO==============[2]
RESPUESTA: " dsport
	
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR============[0] 
SALIR====================[1]
RESPUESTA:  " dex
        if [ $dex == 0 ];
        then 
                b=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	
	if [ $dsport == 0 ];
	then
		mport=--sport
		read -p "
ESCRIBA EL PUERTO DE ORIGEN:
RESPUESTA: " nspor
	elif [ $dsport == 1 ];
	then
		mport=--dport
		read -p "
ESCRIBA EL PUERTO DE DESTINO:
RESPUESTA: " nspor
	else
		echo "
CONTINUANDO" 	
	fi
	read -p "
ELIJA UNA OPCIÓN: 
IPORIGEN===============[0] 
IPDESTINO==============[1] 
SEGRUI=================[2]
RESPUESTA: " resdn
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR============[0] 
SALIR====================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	if [ $resdn == 0 ];
	then
		or=-s
		read -p "
ESCRIBA LA IP Y LA MÁSCARA DE ORIGEN:
RESPUESTA: " ip
	        read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO============[0]
TODOS LOS DESTINOS======[1]
RESPUESTA: " rsip
	        if [ $rsip == 0];
	        then
		
    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0] 
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

		
	            	pr=-d
	                read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL DESTINO:
RESPUESTA " dip
	        fi
	elif [ $resdn == 1 ];
	then
		or=-d
                read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL DESTINO: 
RESPUESTA:  " ip
                read -p "
ELIJA UNA OPCIÓN
AÑADIR UNA IP DE ORIGEN==================[0]
TODOS LOS ORIGENES========================[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DEL ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                        pr=-s
                        read -p "
ESCRIBA LA IP Y LA MÁSCARA DE ORIGEN:
RESPUESTA:  " dip
                fi
	else
		echo "
Continuando...."
	fi

elif [ $optionr == 1 ];
then
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1]
RESPUESTA:  " dex
        if [ $dex == 0 ];
        then 
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	or=-s
	read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip
	read -p "
ELIJA UNA OPCIÓN:
AÑADIR UNA IP DE DESTINO=======[0]
TODOS LOS DESTINOS=============[1]
RESPUESTA: " rsip
	if [ $rsip == 0 ];
	then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
		pr=-d
		read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
	fi

elif [ $optionr == 2 ]; then
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1]
RESPUESTA:  " dex
        if [ $dex == 0 ];
        then 
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
        or=-d
        read -p	"
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " ip
        read -p	"
ELIJA UNA OPCIÓN:
AÑADIR UNA IP DE ORIGEN==========[0]
TODOS LOS ORIGENES===============[1]
RESPUESTA: " rsip
        if [ $rsip == 0 ];
        then
	
	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
		pr=-s
                read -p	"
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
        fi

elif [ $optionr == 3 ]; then
mod=-m
read -p "
ELIJA UN OPCIÓN:
MAC============[0] 
RANGO DE IPS===[1] 
ESTRUCTURA DMZ=[2] 
MULTIPUERTOS===[3]
RESPUESTA: " modulor
if [ $modulor == 0 ];
then
	
	read -p	"
DIRERENCIADOR DE LA MAC===================[0]
SIN DIFERENCIADOR DE LA MAC===============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                d=!
		echo "
Aplicando diferenciador..."
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	module=mac
	modn=--mac-source
	read -p "
ESCRIBA LA DIRECCIÓN MAC DEL EQUIPO:
RESPUESTA " rmod

read -p "
AÑADIR UN PROTOCOLO============[0]
AÑADIR UN IP===================[1]
RESPUESTA: " R

if [ $R == 0 ];
then	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DEL PROTOCOLO============[0]
SIN DIFERENCIADOR DEL PROTOCOLO========[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                a=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
    	pro=-p
	read -p "
ELIJA UNA OPCIÓN:
TCP======[0]
UDP======[1]
RESPUESTA: " pror
        if [ $pror == 0 ];
        then
            	protocolo=tcp
        elif [ $pror == 1 ];
        then
            	protocolo=udp
        fi
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DEL PUERTO=======================[0]
SALIR DEL DIFERENCIADOR DEL PUERTO=============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                b=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	read -p "
ELIJA UNA OPCIÓN: 
PUERTO ORIGEN==============[0] 
PUERTOS DESTINO============[1] 
NIGÚN PUERTO===============[2]
RESPUESTA: " dsport
        if [ $dsport == 0 ];
        then
            	mport=--sport
                read -p "
ESCRIBA EL PUERTO DE ORIGEN:
RESPUESTA: " nspor
        elif [ $dsport == 1 ];
        then
            	mport=--dport
                read -p "
ESCRIBA EL PUERTO DE DESTINO:
RESPUESTA: " nspor
        else
            	echo "Continuando...."
        fi

elif [ $R == 1 ];
then
	read -p "
ELIJA UNA OPCIÓN:
IPORIGEN===============[0] 
IPDESTINO==============[1] 
SEGRUI=================[2]
RESPUESTA: " resdn
        
	read -p	"
ELIJA UN OPCIÓN:
DIRERENCIADOR DE LA IP DE ORIGEN========================[0]
SALIR DEL DIFERENCIADOR DE LA IP DO ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	if [ $resdn == 0 ];
        then
            	or=-s
                read -p "
ESCRIBA LA IP/MÁSCAR DE ORIGEN
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO==========[0]
NO AÑDIR NINGÚN DESTINO====[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi
	
                    	pr=-d
                        read -p "
ESCRIBA LA IP/MÁSCARA DE DESTINO
RESPUESTA: " dip
                fi
        elif [ $resdn == 1 ];
        then
            	or=-d
                read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR DESTINO================[0]
NO AÑADIR NIGÚN DESTINO=======[1] " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-s
                        read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " dip
                fi
        else
            	echo "
Continuando...."
        fi
fi
elif [ $modulor == 1 ];
then
	
	read -p	"
ELIJA UNA OPCIÓN:
DIFERENCIADOR DEL RANGO DE IPS============[0] 
SALIR DEL DIFERENCIADOR DEL RANGO DE IPS==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                d=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	module=iprange
	read -p "
ELIJA UNA OPCIÓN:
RANGO DE IPS: ORIGEN===================[0] 
RANGO DE IPS: DESTINO==================[1]
RESPUESTA: " riprange
		if [ $riprange == 0 ];
		then
			modn=--src-range
			read -p "
ELIJA EL RANGO DE IPS DE ORIGEN: 
RESPUESTA: " rmod
		elif [ $riprange == 1 ];
		then
			modn=--dst-range
			read -p "
ELIJA EL RANGO DE IPS DE DESTINO
RESPUESTA: " rmod
		fi
	read -p "
ELIJA UNA OPCIÓN: 
SELECCIONAR UNA IP DE ORIGEN=================[0] 
SELECCIONAR UNA IP DE DESTINO================[1] 
sALIR DE LA CONFIGURACIÓN DE IP==============[2]
RESPUESTA: " resdn
       
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE LA IP DE ORIGEN=====================[0]
SALIR DEL DIFERENCIADOR DE IP DE ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	if [ $resdn == 0 ];
        then
            	or=-s
                read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA:  " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO==========[0]
TODOS LOS DESTINOS=========[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-d
                        read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
                fi
        elif [ $resdn == 1 ];
        then
            	or=-d
                read -p "
ESCRIBA LA IP Y LA MÁSCARA DE DESTINO:
RESPUESTA:  " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN ORIGEN============[0]
TODOS LOS ORIGENES==========[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-s
                        read -p "
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
                fi
        else
            	echo "
Continuando...."
        fi
elif [ $modulor == 2 ];
then
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DEL ESTADO DE LOS PAQUETES========================[0] 
SALIR DEL DIFERENCIADOR DEL ESTADO DE LOS PAQUETES==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                d=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	module=state
	modn=--state
	read -p "
ESCRIBA LA COMUNICACION DE LOS PAQUETES:
RESPUESTA: " rmod
	
	read -p "
ELIJA UNA OPCION
AÑADIR MAC DE ORIGEN============[0]
TODAS LAS MACS==================[1]
RESPUESTA: " respuma
	if [ $respuma == 0 ];
	then
		module=mac
	        modn=--mac-source
        	read -p "
AÑADA LA DIRECCIÓN MAC:
RESPUESTA:" rmod
	elif [ $respuma == 1 ];
	then
		echo "
Continuando...."
	fi
	
	read -p "
ELIJA UNA OPCIÓN: 
AÑADIR IP DE ORIGEN===============[0] 
AÑADIR IP DE DESTINO==============[1] 
SEGRUIR LA CONFIGURACIÓN==========[2]
RESPUESTA: " resdn
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE LA IP DE ORIGEN========================[0] 
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	
		        if [ $resdn == 0 ];
		        then
            		or=-s
       	read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN: 
RESPUESTA: " ip
       	read -p "
ELIJA UNA OPCIÓN:
AÑADIR UNA IP DE DESTINO===========[0]
TODOS LOS DESTINOS=================[1]
RESPUESTA: " rsip
                	if [ $rsip == 0 ];
                	then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
               		     	pr=-d
       	read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
                	fi
        	elif [ $resdn == 1 ];
        	then
            		or=-d
                read -p "
ESCRIBA LA IP/MÁSCARA DE DESTINO:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO==============[0]
TODOS LOS DESTINOS=============[1]
RESPUESTA: " rsip
                	if [ $rsip == 0 ];
                	then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DELA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    		pr=-s
                read -p "
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA:  " dip
                	fi
       		else
            		echo "
Continuando...."
        	fi
	
	
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DEL PUERTO========================[0] 
SALIR DEL DIFERENCIADOR DEL PUERTO==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                a=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 

	pro=-p
	read -p " 
ELIJA UNA OPCION:
TCP======[0] 
UDP======[1]
RESPUESTA: " pror
        if [ $pror == 0 ];
        then
            	protocolo=tcp
        elif [ $pror == 1 ];
        then
            	protocolo=udp
        fi
	read -p "
ELIJA UNA OPCIÓN: 
PUERTO ORIGEN==========[0] 
PUERTOS DESTINO============[1] 
NIGÚN PUERTO=========[2]
RESPUESTA: " dsport
        
	read -p	"
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE PUERTOS========================[0] 
SALIR DEL DIFERENCIADOR DE PUERTOS==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then 
                b=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi 
	
	if [ $dsport == 0 ];
       		then
            	mport=--sport
       	read -p "
ESCRIBA EL PUERTO DE ORIGEN:
RESPUESTA: " nspor
        elif [ $dsport == 1 ];
        	then
            	mport=--dport
        read -p "
ESCRIBA EL PUERTO DE DESTINO:
RESPUESTA: " nspor
        elif [ $dsport == 2 ];
	then
            	echo "Continuando...."
        fi
	
fi
elif [ $modulor == 3 ];
then
	
        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DEL PROTOCOLO=======================[0] 
SALIR DEL DIFERENCIADOR DE PROTOCOLO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	a=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                pro=-p
            	read -p "
ELIJA UNA OPCIÓN:
TCP======[0] 
UDP======[1]
RESPUESTA: " pror
                if [ $pror == 0 ];
                then
                        protocolo=tcp
                elif [ $pror == 1 ];
                then
                        protocolo=udp
                fi

	
	module=multiport
	read -p "
ELIJA UNA OPCIÓN:
PUERTOS DE ORIGEN============[0] 
PUERTOS DE DESTINO===========[1]
RESPUESTA: " multiportr
	
	read -p "
ELIJA UNA OPCIÓN: 
DIRERENCIADOR DE PUERTOS========================[0] 
SALIR DEL DIFERENCIADOR DE PUERTOS==============[1] " dex
        if [ $dex == 0 ];
        then
            	b=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	if [ $multiportr == 0 ];
	then
		modn=--dports
		read -p "
ESCRIBE EL NUMERO DE LOS PUERTOS:
RESPUESTA: " rmod
	elif [ $multiportr == 1 ];
	then
		modn=--sports
		read -p "
ESCRIBE EL NUEVO DE LOS PUERTOS:
RESPUESTA: " rmod
	fi
	read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN ORIGEN|DESTINO=========[0]
NO AÑADIR NADA===================[1]
RESPUESTA: " multiportres
	
	if [ $multiportres == 0 ];
	then
	read -p "
ELIJA UNA OPCIÓN: 
ELEGIR ORIGEN==========[0] 
ELEGIR DESTINO==========[1]
RESPUESTA: " optrmul
			
	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN========================[0] 
SALIR DEL DIFERENCIADOR DE IP DE ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	c=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi
			if [ $optrmul == 0 ];
			then
   				or=-s
			read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip
		        read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO=============[0]
TODOS LOS DESTINOS============[1]
RESPUESTA: " rsip
			        if [ $rsip == 0 ];
       				then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
      		 		    	pr=-d
      		 	        read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
				fi
	
			elif [ $optrmul == 1 ];
			then
               	        or=-d
         		        read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL DESTINO:
RESPUESTA: " ip
         	                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN ORIGEN==========[0]
TODOS LOS ORIGENES========[1] 
RESPUESTA: " rsip
            				if [ $rsip == 0 ];
             			        then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                      				pr=-s
                 		read -p "
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTAS: " dip
                	    		fi
		fi        	
	elif [ $multiportres == 'N' ] || [ $multiportres == 'n' ];
	then
		echo "Continuando...."
	fi
	
#elif [ $optionr == 4 ];
#then
#	read -p "SNAT/DNAT/MASQUERADE" rnat
#	if [ $rnat == 'MASQUERADE' ] || [ $rnat == 'masquerade' ] || [ -z "$rnat" ]
#        then
#            	tab=-t
#		nat=nat
#		salida=-o
#		int=$int1
#                
#        elif [ $rnat == 'SNAT' ] || [ $rnat == 'snat' ]
#        then
#            	tab=-t
#		nat=nat
#		oi=-o
#		int=$int1
#       elif [ $rnat == 'DNAT' ] || [ $rnat == 'dnat' ]
#        then
#            	tab=-t
#		nat=nat
#		oi=-i
#		int=$int1
#        fi 
elif [ $optionr == 4 ];
then
 for (( ; ; ))
 do
   	read -p "PULSE INTRO PARA SALIR..." resp
        if [ -z $resp ]
        then
            	break
        else
            	break
        fi
 done



fi

elif [ $pnormar == 2 ]; 
then

	pnorma=-D
read -p "
ELIJA UNA OPCION:
INPUT======[0] 
OUTPUT=====[1] 
FORWARD====[2] 
POSTROUTING[3] 
PREROUTING=[4]
PERSONALIZADO[5] 
RESPUESTA: " snormar

if [ $snormar == 0 ]; then
        snorma=INPUT

elif [ $snormar == 1 ]; then
        snorma=OUTPUT

elif [ $snormar == 2 ]; then
        snorma=FORWARD

elif [ $snormar == 3 ]; then
        snorma=POSTROUTING

elif [ $snormar == 4 ]; then
        snorma=PREROUTING
elif [ $snormar == 5 ]; then

	read -p "
ESCRIBE EL NOMBRE:
RESPUESTA: " snorma
fi

iptables -L -nv --line-numbers

read -p "ELIJA UN NÚMERO: " number

 for (( ; ; ))
 do
	read -p "PULSE INTRO PARA SALIR..." resp 
	if [ -z $resp ]
	then
                break
	else
		break
	fi
 done

elif [ $pnormar == 3 ]; 
then
	pnorma=-C

elif [ $pnormar == 4 ]; 
then
	pnorma=-E 
elif [ $pnormar == 5 ]
then
	pnorma=-N
	read -p "
ESCRIBA UN NOMBRE:
RESPUESTA: " nomn
fi

read -p " 
ELIJA UNA OPCIÓN:
INPUT================[0] 
OUTPUT===============[1] 
FORWARD==============[2] 
POSTROUTING==========[3] 
PREROUTING===========[4]
PERSONALIZADO========[5] 
SALIR================[6]
RESPUESTA: " snormar

if [ $snormar == 0 ]; then
	snorma=INPUT

elif [ $snormar == 1 ]; then
	snorma=OUTPUT

elif [ $snormar == 2 ]; then
	snorma=FORWARD

elif [ $snormar == 3 ]; then
	snorma=POSTROUTING

elif [ $snormar == 4 ]; then
	snorma=PREROUTING
elif [ $snormar == 5 ]; then
	read -p "
ESCRIBA EL NOMBRE:
RESPUESTA: " snorma
elif [ $snormar == 6 ]; then
 for (( ; ; ))
 do
   	read -p "PULSE INTRO PARA SALIR..." resp
        if [ -z $resp ]
        then
            	break
        else
            	break
        fi
 done

fi

read -p " 
ELIJA UNA OPCIÓN:
PROTOCOLO==========[0] 
ORIGEN=============[1] 
DESTINO============[2] 
MODULO=============[3] 
NAT ===============[4] 
SALIR==============[5]
RESPUESTA: " optionr

if [ $optionr == 0 ];
then
	        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DEL PROTOCOLO============[0] 
SALIR==============================[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	a=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	pro=-p
	read -p "
ELIJA UNA OPCIÓN:
TCP======[0] 
UDP======[1]
RESPUESTA: " pror
	if [ $pror == 0 ];
	then
		protocolo=tcp
	elif [ $pror == 1 ];
	then
		protocolo=udp
	fi
	read -p "
ELIJA UNA OPCIÓN:
PUERTO ORIGEN==============[0] 
PUERTOS DESTINO============[1] 
NIGÚN PUERTO===============[2]
RESPUESTA: " dsport
	
        read -p "
ELIJA UNA OPCION:
DIRERENCIADOR DEL PUERTO============[0] 
SALIR===============================[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	b=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	if [ $dsport == 0 ];
	then
		mport=--sport
		read -p "
ESCRIBA EL PUERTO DE ORIGEN:
RESPUESTA: " nspor
	elif [ $dsport == 1 ];
	then
		mport=--dport
		read -p "
ESCRIBA EL PUERTO DE DESTINO:
RESPUESTA " nspor
	else
		echo "Continuando...." 	
	fi
	read -p "
ELIJA UNA OPCIÓN: 
AÑADIR IP DE ORIGEN===============[0] 
AÑADIR IP DE DESTINO==============[1] 
SEGRUI============================[2]
RESPUESTA: " resdn
	
        read -p "
ELIJA UNA OPCION:
DIRERENCIADOR DE IP============[0] 
SALIR==========================[1]
RESPUESTA:  " dex
        if [ $dex == 0 ];
        then
            	c=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	if [ $resdn == 0 ];
	then
		or=-s
		read -p "
ESCRIBA LA IP Y LA MÁSCARA DE ORIGEN:
RESPUESTA: " ip
	        read -p "
ELIJA UNA OPCIÓN
AÑADIR UN DESTINO===========[0]
TODOS LOS DESTINOS==========[1]
RESPUESTA: " rsip
	        if [ $rsip == 0 ];
	        then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	            	pr=-d
	                read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL DESTINO:
RESPUESTA: " dip
	        fi
	elif [ $resdn == 1 ];
	then
		or=-d
                read -p "
ESCRIBA LA IP/MÁSCARA DE DESTINO: " ip
                read -p "
ELIJA UNA OPCIÓN
AÑADIR IP DE ORIGEN ===========[0]
TODOS LOS ORIGENES=============[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                        pr=-s
                        read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
                fi
	else
		echo "
Continuando...."
	fi

elif [ $optionr == 1 ];
then
	
        read -p "
ELIJA UNA OPCION
DIRERENCIADOR DE LA IP============[0] 
SALIR=============================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	c=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	or=-s
	read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN: 
RESPUESTA: " ip

	read -p "
ELIJA  UNA OPCIÓN
AÑADIR IP DE DESTINO=============[0]
TODOS LOS DESTINOS===============[1]
RESPUESTA: " rsip
	if [ $rsip == 0 ];
	then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
		pr=-d
		read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
	fi

elif [ $optionr == 2 ]; then
	
        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP============[0] 
SALIR==========================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
        or=-d
        read -p	"
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " ip

        read -p	"
ELIJA UNA OPCIÓN:
AÑADIR UN IP DE ORIGEN========[0]
TODOS LOS ORIGENES============[1]
REASPUESTA: " rsip
        if [ $rsip == 0 ];
        then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
		pr=-s
                read -p	"
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
        fi

elif [ $optionr == 3 ]; then
mod=-m
read -p " 
ELIJA UNA OPCIÓN:
MAC============[0] 
RANGO DE IPS===[1] 
ESTRUCTURA DMZ=[2] 
MULTIPUERTOS===[3]
RESPUESTA: " modulor
if [ $modulor == 0 ];
then
	
        read -p "
ELIJA UNA OPCION:
DIRERENCIADOR DE MAC============[0] 
SALIR===========================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                d=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	module=mac
	modn=--mac-source
	read -p "
AÑADA LA DIRECCIÓN MAC:
RESPUESTA: " rmod

	
        read -p "
ELIJA UNA OPCION:
DIRERENCIADOR DEL PROTOCOLO============[0] 
SALIR==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                a=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
    	pro=-p
	read -p " 
ELIJA UNA OPCION:
TCP======[0] 
UDP======[1]
RESPUESTA: " pror
        if [ $pror == 0 ];
        then
            	protocolo=tcp
        elif [ $pror == 1 ];
        then
            	protocolo=udp
        fi
	read -p "
ELIJA UNA OPCIÓN: 
PUERTO ORIGEN==============[0] 
PUERTOS DESTINO============[1] 
NIGÚN PUERTO===============[2]
RESPUESTA: " dsport
        
        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE PUERTO============[0] 
SALIR==============================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                b=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	if [ $dsport == 0 ];
        then
            	mport=--sport
                read -p "
ESCRIBA EL PUERTO DE ORIGEN: 
RESPUESTA: " nspor
        elif [ $dsport == 1 ];
        then
            	mport=--dport
                read -p "
ESCRIBA EL PUERTO DE DESTINO: 
RESPUESTA: " nspor
        else
            	echo "Continuando...."
        fi

	read -p "
ELIJA UNA OPCIÓN: 
AÑADA UNA IP DE ORIGEN===============[0] 
AÑADA UNA IP DE DESTINO==============[1] 
SEGRUI===============================[2]
RESPUESTA: " resdn
        
        read -p "
ELIAJ UNA OPCION:
DIRERENCIADOR DE IP============[0] 
SALIR==========================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	if [ $resdn == 0 ];
        then
            	or=-s
                read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCION:
AÑADIR UNA IP DE DESTINO==========[0]
TODOS LOS DESTINOS================[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-d
                        read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
                fi
        elif [ $resdn == 1 ];
        then
            	or=-d
                read -p "
ESCRIBA LA IP/MÁSCARA DE DESTINO:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCION:
AÑADIR UN DESTINO==========[0]
TODOS LOS DESTINOS=========[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-s
                        read -p "
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
                fi
        else
            	echo "
Continuando...."
        fi

elif [ $modulor == 1 ];
then
	module=iprange
	read -p "
ELIJA UNA OPCIÓN:
RANGO DE IPS DE ORIGEN=====[0] 
RANGO DE IPS DE DESTINO====[1]
RESPUESTA: " riprange
		
	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE EL RANGO DE IPS============[0] 
SALIR DEL DIFERENCIADOR DE RANGO DE IPS=====[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                d=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

		
		if [ $riprange == 0 ];
		then
			modn=--src-range
			read -p "
ELIJA EL RANGO DE IPS DE ORIGEN:
RESPUESTA: " rmod
		elif [ $riprange == 1 ];
		then
			modn=--dst-range
			read -p "
ELIJA EL RANGO DE IPS DE DESTINO:
RESPUESTA: " rmod
		fi
	read -p "
ELIJA UNA OPCIÓN: 
AÑADIR IP DE ORIGEN===============[0] 
AÑADIR IP DE DESTINO==============[1] 
SEGRUIR CON LA CONFIGURACIÓN======[2]
RESPUESTA: " resdn
        
        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN========================[0] 
SALIR DEL DIFERENCIADOR DE IP DE ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	if [ $resdn == 0 ];
        then
            	or=-s
                read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑDIR UNA IP DE DESTINO===========[0]
TODOS LOS DESTINOS================[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-d
                        read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
                fi
        elif [ $resdn == 1 ];
        then
            	or=-d
                read -p "
ESCRIBA LA IP/MÁSCARA DE DESTINO:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO============[0]
TODOS LOS DESTINOS===========[1]
RESPUESTA: " rsip
                if [ $rsip == 0 ];
                then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    	pr=-s
                        read -p "
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
                fi
        else
            	echo "Continuando...."
        fi
elif [ $modulor == 2 ];
then
	module=state
	modn=--state
	read -p "
ESCRIBA LA COMUNICACION DE LOS PAQUETES:
RESPUESTA: " rmod
	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE LOS ESTADOR DE LOS PAQUETES====================[0] 
SALIR DEL DIFERENCIADOR DE LOS ESTADOS DE LOS PAQUETES==========[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                d=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	read -p "
ELIJA UNA OPCIÓN:
AÑADIR UNA MAC============[0]
NO AÑADIR NIGUNA MAC======[1]
RESPUESTA: " respuma
	if [ $respuma == 0 ];
	then
        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE LA MAC========================[0] 
SALIR DEL DIFERENCIADOR DE LA MAC==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                d=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

		module=mac
	        modn=--mac-source
        	read -p "
ESCRIBA LA DIRECCIÓN MAC:
RESPUESTA: " rmod
	elif [ $respuma == 'N' ] || [ $respuma == 'n' ];
	then
		echo "
Continuando...."
	fi
	
	read -p "
ELIJA UNA OPCIÓN: 
AÑADIR IP DE ORIGEN===============[0] 
AÑADIR IP DE DESTINO==============[1] 
SEGRUIR CON LA ONFIGURACIÓN=======[2]
RESPUESTA: " resdn
		        
        read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE LA IP DE ORIGEN=====================[0] 
SALIR DEL DIFERENCIADOR DE IP DE ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

			
			if [ $resdn == 0 ];
		        then
            		or=-s
       	read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip

       	read -p "
ELIJA UNA OPCIÓN:
AÑADIR UNA IP DE DESTINO=============[0]
TODOS LOS DESTINOS===================[1]
RESPUESTA: " rsip
                	if [ $rsip == 0 ];
                	then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
               		     	pr=-d
       	read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
                	fi
        	elif [ $resdn == 1 ];
        	then
            		or=-d
                read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL DESTINO:
RESPUESTA: " ip
                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UNA IP DE ORIGEN===========[0]
TODOS LOS ORIGENES================[1]
RESPUESTA: " rsip
                	if [ $rsip == 0 ];
                	then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===========================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORGIEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
                    		pr=-s
                read -p "
ESCRIBA LA IP/MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
                	fi
       		else
            		echo "
Continuando...."
        	fi



        read -p "
ELIJE UNA OPCIÓN:
DIRERENCIADOR DE PROTOCOLO===========[0] 
SALIR================================[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                a=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi



	pro=-p
	read -p " 
ELIJA UNA OPCIÓN:
TCP======[0] 
UDP======[1]
RESPUESTA: " pror
        if [ $pror == 0 ];
        then
            	protocolo=tcp
        elif [ $pror == 1 ];
        then
            	protocolo=udp
        fi
	read -p "
ELIJA UNA OPCIÓN: 
PUERTO ORIGEN==============[0] 
PUERTOS DESTINO============[1] 
NIGÚN PUERTO===============[2]
RESPUESTA: " dsport
        
        read -p "
ELIJA UNA OPCIÓN
DIRERENCIADOR DE PUERTOS========================[0] 
SALIR DEL DIFERENCIADOR DE PUERTOS==============[1] " dex
        if [ $dex == 0 ];
        then
                b=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	
	if [ $dsport == 0 ];
       		then
            	mport=--sport
       	read -p "
ESCRIBA EL PUERTO DE ORIGEN: 
RESPUESTA: " nspor
        elif [ $dsport == 1 ];
        	then
            	mport=--dport
        read -p "
ESCRIBA EL PUERTO DE DESTINO:
RESPUESTA: " nspor
        elif [ $dsport == 2 ];
	then
            	echo "
Continuando..."
        fi

		

	
fi

elif [ $modulor == 3 ];
then
	
        read -p "
ELIJA UNA OPCIÓN:
DIFERENCIADOR DE PROTOCOLO========================[0] 
SALIR DEL DIFERENCIADOR DE PROTOCOLO==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                a=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
	
                pro=-p
            	read -p "
ELIJA UNA OPCIÓN
TCP======[0]
UDP======[1]
RESPUESTA: " pror
                if [ $pror == 0 ];
                then
                        protocolo=tcp
                elif [ $pror == 1 ];
                then
                        protocolo=udp
                fi

	read -p "
ELIJA UNA OPCIÓN:
DIFERENCIADOR DE PUERTOS========================[0] 
SALIR DEL DIFERENCIADOR DE PUERTOS==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                b=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	module=multiport
	read -p "
ELIJA UNA OPCIÓN:
PUERTOS DE ORIGEN======[0] 
PUERTOS DE DESTINO=====[1]
RESPUESTA: " multiportr
	if [ $multiportr == 0 ];
	then
		modn=--dports
		read -p "
ESCRIBE EL NUMERO DE LOS PUERTOS DE DESTINO: 
RESPUESTA: " rmod
	elif [ $multiportr == 1 ];
	then
		modn=--sports
		read -p "
ESCRIBE EL NÚMERO DE LOS PUERTOS DE ORIGEN:
RESPUESTA: " rmod

	fi
	read -p "
ELIJA UNA OPCIÓN:
CONFIGURAR IP==========[0]
CONTINUAR==============[1]
RESPUESTA: " multiportres
	if [ $multiportres == 0 ];
	then
	read -p "
ELIJA UNA OPCIÓN: 
ELEGIR IP DE ORIGEN===========[0] 
ELEGIR IP DE DESTINO==========[1]
RESPUESTA: " optrmul
			
        read -p "
ELIJE UNA OPCIÓN:
DIFERENCIADOR DE IP DE ORIGEN===================[0] 
SALIR DEL DIFERENCIADOR DEL ORIGEN==============[1]
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
                c=!
        elif [ $dex == 1 ];
        then
                echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
			if [ $optrmul == 0 ];
			then
   				or=-s
			read -p "
ESCRIBA LA IP/MÁSCARA DE ORIGEN:
RESPUESTA: " ip
		        read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN DESTINO============[0]
TODOS LOS DESTINOS===========[1]
RESPUESTA:  " rsip
			        if [ $rsip == 0 ];
       				then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE DESTINO===================[0]
SALIR DEL DIFERENCIADOR DEL DESTINO==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "
OPCIÓN: SIN DIFERENCIADOR"
        fi

	
      		 		    	pr=-d
      		 	        read -p "
ESCRIBA LA IP/MÁSCARA DEL DESTINO:
RESPUESTA: " dip
				fi
	
			elif [ $optrmul == 1 ];
			then
               	        or=-d
         		        read -p "
ESCRIBA LA IP/MÁSCARA DE DESTINO:
RESPUESTA: " ip
         	                read -p "
ELIJA UNA OPCIÓN:
AÑADIR UN ORIGEN============[0]
TODOS LOS LOS ORIGENES======[1]
RESPUESTA: " rsip
            				if [ $rsip == 0 ];
             			        then
	
	    	read -p "
ELIJA UNA OPCIÓN:
DIRERENCIADOR DE IP DE ORIGEN===========================[0]
SALIR DEL DIFERENCIADOR DE LA IP DE ORIGEN==============[1] 
RESPUESTA: " dex
        if [ $dex == 0 ];
        then
            	e=!
        elif [ $dex == 1 ];
        then
            	echo "OPCIÓN: SIN DIFERENCIADOR"
        fi


      				pr=-s
                 		read -p "
ESCRIBA LA IP Y LA MÁSCARA DEL ORIGEN:
RESPUESTA: " dip
                	    		fi
		fi        	
	elif [ $multiportres == 'N' ] || [ $multiportres == 'n' ];
	then
		echo "
Continuando..."
	fi
	
elif [ $optionr == 4 ];
then
	read -p "
ELIJA UNA OPCIÓN:
MASQUERADE==============[0]
SNAT====================[1]
DNAT====================[2]
RESPUESTA: " rnat
	if [ $rnat == 0 ];
        then
            	tab=-t
		nat=nat
		salida=-o
		int=$int1
                
        elif [ $rnat == 1 ];
        then
            	tab=-t
		nat=nat
		oi=-o
		int=$int1
        elif [ $rnat == 2 ];
        then
            	tab=-t
		nat=nat
		oi=-i
		int=$int1
        fi 
elif [ $optionr == 5 ];
then
 for (( ; ; ))
 do
   	read -p "PULSE INTRO PARA SALIR..." resp
        if [ -z $resp ]
        then
            	break
        else
            	break
        fi
 done


fi

read -p " 
ELIJA UNA OPCIÓN:
DROP============[0] 
REJECT==========[1] 
ACCEPT==========[2] 
LOG=============[3] 
MASQUERADE======[4] 
SNAT============[5] 
DNAT============[6]
PERSONALIZADO===[7]
NADA============[8]
RESPUESTA: " finormar

if [ $finormar == 0 ]; then
	
	jump=-j
	fin=DROP
elif [ $finormar == 1 ]; then
	
	jump=-j
	fin=REJECT
elif [ $finormar == 2 ]; then
	
	jump=-j
	fin=ACCEPT 
elif [ $finormar == 3 ]; then
	
	jump=-j
	fin=LOG
	read -p "
ELIJA UNA OPCIÓN:
PONERLE UN NOMBRE IDENTIFICATIVO=============[0]
NO PONERLE NIGUNA IDENTIFICACIÓN=============[1]
RESPUESTA: " logr
	if [ $logr == 0 ]
	then
		prefijo=--log-prefix
		read -p "
ESCRIBA EL NOMBRE IDENTIFICATIVO:
RESPUESTA " nlog
		idlog="\"$nlog"\"
	fi
elif [ $finormar == 4 ]; then
        
	jump=-j
	fin=MASQUERADE
elif [ $finormar == 5 ]; then
        
	jump=-j
	fin=SNAT
	destino=--to
	read -p "
ESCRIBA LA DIRECION IP DEL DESTINO: 
RESPUESTA:" rsnat
elif [ $finormar == 6 ]; then
        
	jump=-j
	fin=DNAT  
        destino=--to
        read -p	"
ESCRIBA LA DIRECION IP	DEL DESTINO: 
RESPUESTA: " rsnat

elif [ $finormar == 7 ]; then
	jump=-j
read -p "
ESCRIBA EL NOMBRE AL QUE VA A SER DIRIGIDO:
RESPUESTA: " nomnr

elif [ $finormar == 8 ]; then
 for (( ; ; ))
 do
   	read -p "PULSE INTRO PARA SALIR..." resp
        if [ -z $resp ]
        then
            	break
        else
            	break
        fi
 done


fi

iptables $pnorma $snorma  $nomn $number $a $pro $protocolo $b $mport $nspor $c $or $ip $e $pr $dip $mod $module $d $modn $rmod $tab $nat $oi $int $jump $fin $prefijo $idlog $destino $rsnat $nomnr

echo " iptables $pnorma $snorma $nomn $number $a $pro $protocolo $b $mport $nspor $c $or $ip $e $pr $dip $mod $module $d $modn $rmod $tab $nat $oi $int $jump $fin $prefijo $idlog $destino $rsnat $nomnr "

