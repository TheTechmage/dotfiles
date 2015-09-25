#!/bin/bash
#echo "[TODO] Furc Status Check"
echo -n '${color fea63c}Furcadia LW Status: ${color 21face}'
#fport=$(nmap -oG - -T4 -p6500 -v lightbringer.furcadia.com|grep -o open)
if [ ! -z $fport ] ; then
	echo '${color 21face}Online'
else
	echo '${color fa2121}Offline'
fi
echo -n '$color'

echo -n '${color fea63c}Furcadia Pounce:${color 21face}${texeci 480 echo "REPLACE ME"}$color'

