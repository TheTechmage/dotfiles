#!/bin/bash
#echo "[TODO] Furc Status Check"
fport=$(nmap -oG - -T4 -p6500 -v lightbringer.furcadia.com|grep -o open)
if [ ! -z $fport ] ; then
	echo "Online"
else
	echo "Offline"
fi
