#!/bin/bash

DEFAULT_SESSION='ssubtle'
if [[ "$(hostname)" == "Ogre" ]]; then
	DEFAULT_SESSION='sdwm'
	/usr/bin/start-pulseaudio-x11 &
fi

function sxmonad() {
	PATH=$PATH:~/bin:~/fbin
	#xmonad | dzen2
	fscreen p2n
        xsetroot -cursor_name left_ptr &
        xrdb ~/.Xdefaults &
        ~/bin/tray &
        #gnome-terminal &
        #xscreensaver &
	pulseaudio --kill && pulseaudio --start &
        xmonad
}

function ssubtle() {
	#gnome-session
	xautolock -time 10 -locker "slimlock" &
	if [[ "$(hostname)" == "Toronto" ]]; then
		xrandr --output DVI-I-2 --right-of DVI-I-1 &
	fi
	sbg &
	subtle
	synclient MaxTapTime=0
}
function sdwm() {
	xautolock -time 10 -locker "slimlock" &
	sbg &
	if [[ "$(hostname)" == "Ogre" ]]; then
		xscreensaver &
	fi
	dwm
}
function sbg() {
	sleep 1;
	if [ "$(hostname)" == "Toronto" ]; then
		feh --bg-fill ~/bg.jpg;
	else
		feh --bg-fill ~/.wallpapers/archlinux-wallpaper-1.3/archlinux-deep-aurora.jpg;
	fi;
}

xset +fp /usr/share/fonts/local
case $1 in
xmonad)
	sxmonad
	;;
subtle)
	ssubtle
	;;
dwm)
	sdwm
	;;
bg)
	sbg
	;;
*)
	#exec $0 $DEFAULT_SESSION
	$DEFAULT_SESSION
	;;
esac
