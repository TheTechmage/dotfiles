ip a show dev wlan0 | grep -w inet | awk '{print $2;}'
