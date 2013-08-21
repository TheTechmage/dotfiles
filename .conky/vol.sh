#!/bin/bash
vol=`amixer get Master | grep "Mono:" | awk '{print $4}'`
if [ $vol == "[0%]" ]
then 
	echo "[Mute]"
else
	echo $vol|egrep -o '[0-9]+'
fi
