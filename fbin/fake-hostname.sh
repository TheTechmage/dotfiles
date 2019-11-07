#!/bin/bash

frosty_hostname() {
	local frostyhostname="$(hostname)"
	if [[ "$frostyhostname" == *desktop ]];
	then
		echo -n "Brownie"
	else
		echo -n "${frostyhostname}"
	fi
}

frosty_hostname
