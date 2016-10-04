#!/bin/bash

DEFAULT_SESSION='sdwm'
if [[ "$(hostname)" == "Ogre" ]]; then
	DEFAULT_SESSION='sdwm'
	xrandr --setprovideroutputsource modesetting NVIDIA-0
	xrandr --auto
	/usr/bin/start-pulseaudio-x11 &
fi
#if [[ "$(hostname)" == "Troll" ]]; then
#	DEFAULT_SESSION='sxfce'
#fi
#if [[ "$(hostname)" == "London" ]]; then
#	DEFAULT_SESSION='sxfce'
#fi
function japanese() {
	export XMODIFIERS=@im=SCIM
	export GTK_IM_MODULE="scim"
	export QT_IM_MODULE="scim"
	scim -d
}

function common() {
	sbg &
	dunst &
	sleep 1
	japanese
	#conky & # Need conky-lua
}

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
function sxfce() {
	if [[ "$(hostname)" == "London" ]]; then
		xrandr --output DVI-0 --right-of HDMI-0 &
	fi
	xfce4-session
}

function ssubtle() {
	#gnome-session
	xautolock -time 10 -locker "slimlock" &
	if [[ "$(hostname)" == "Troll" ]]; then
		xrandr --output DVI-I-2 --right-of DVI-I-1 &
	fi
	subtle
	synclient MaxTapTime=0
}

function sdwm() {
	xautolock -time 10 -locker "slock" &
	#if [[ "$(hostname)" == "Ogre" ]]; then
		#xscreensaver &
	#fi
	dwmstatus &
	exec dwm
}
function sxfce() {
	xscreensaver &
	xfce4-session
}
function sbg() {
	sleep 1;
	if [ "$(hostname)" == "Troll" ]; then
		feh --bg-fill ~/bg.jpg;
	elif [ "$(hostname)" == "Ogre" ]; then
		feh --bg-fill ~/minimalist_arch_linux_wallpaper__1920x1200__by_jesuisnerd-d4x1ofc.png;
	else
		feh --bg-fill ~/.wallpapers/archlinux-wallpaper-1.3/archlinux-deep-aurora.jpg;
	fi;
}

xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/100dpi/
xrdb -merge ~/.Xresources

env >> /tmp/test
echo >> /tmp/test

case $1 in
xmonad)
	common
	sxmonad
	;;
subtle)
	common
	ssubtle
	;;
dwm)
	common
	feh --bg-fill ~/.wallpapers/archlinux-wallpaper-1.3/archlinux-deep-aurora.jpg;
	#sleep 5;
	sdwm
	;;
xfce)
	common
	sxfce
	;;
bg)
	sbg
	;;
*)
	#exec $0 $DEFAULT_SESSION
	exec $0 dwm
	#$DEFAULT_SESSION
	;;
esac
