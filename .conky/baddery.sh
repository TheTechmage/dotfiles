#! /bin/bash

# script to return the battery time remaining, or status if no time is given.
# ### Requires: acpi package ###


# Discharging
#############
batt=`acpi -b | grep "Discharging"`
if [[ $batt != "" ]];
then
	batt=`echo $batt | awk '{print $5}' | cut -c 1-5`
	echo $batt", Discharging"
	exit 1
fi

# Charging
##########
butt=`acpi -b | grep "Charging"`
if [[ $butt != "" ]];
then
	butt=`echo $butt | awk '{print $5}' | cut -c 1-5`
	echo " "$butt", Charging"
	exit 1
fi

# Fully Charged
###############
bott=`acpi -b | grep "Full"`
if [[ $bott != "" ]];
then
	echo "   Fully Charged"
	exit 1
fi

# Unknown State
###############
bitt=`acpi -b | grep "Unknown"`
if [[ $bitt != "" ]];
then
	echo "  -unknown state-"
fi
