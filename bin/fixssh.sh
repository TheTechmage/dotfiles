#!/bin/sh
die () {
	echo >&2 "$@"
	exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"
#echo $1 | grep -E -q '^(([0-9]{1,3}\.){1,3}[0-9]{1,3}|[a-b0-9\.]{1,25})$' || die "IP or hostname argument required, $1 provided"

ssh $1 mkdir -p .terminfo/r
scp /usr/share/terminfo/r/rxvt-unicode* $1:.terminfo/r/
