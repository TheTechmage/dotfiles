#!/bin/bash
vol=`amixer get Master | grep "Left:" | awk '{print $5}'`
volmute=`amixer get Master | grep "Left:" | awk '{print $6}'`
# amixer get Master | grep Left: | cut -d " " -f7
if [[ $volmute == "[off]" ]]
then 
	echo "[Mute]"
else
	echo $vol
fi
