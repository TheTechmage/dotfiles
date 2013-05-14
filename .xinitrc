#!/bin/bash

DEFAULT_SESSION='sgnome'

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

function sgnome() {
	#gnome-session
	xautolock -time 10 -locker "slimlock" &
	feh --bg-fill ~/.wallpapers/archlinux-wallpaper-1.3/archlinux-deep-aurora.jpg &
	subtle
	synclient MaxTapTime=0
}

xset +fp /usr/share/fonts/local
case $1 in
xmonad)
	sxmonad
	;;
gnome)
	sgnome
	;;
bg)
	feh --bg-fill ~/.wallpapers/archlinux-wallpaper-1.3/archlinux-deep-aurora.jpg &
	;;
*)
	#exec $0 $DEFAULT_SESSION
	$DEFAULT_SESSION
	;;
esac
