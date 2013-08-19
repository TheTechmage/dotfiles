#!/bin/bash
bat=$(acpi)
if [ "$(echo $bat|grep Battery)" != "" ];
then
	echo -en " "
	echo $bat|awk '{print $4;}'|egrep -o '[0-9]+'|tr -d '\n'
	echo -en "%"
	#echo -en " " # unnecessary?
fi
