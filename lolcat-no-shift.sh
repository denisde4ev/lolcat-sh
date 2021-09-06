#!/bin/sh
set -eu


o=${0##*[/\\]} # for busybox-w32
#o=${0%.sh} # todo trim *".sh"

# todo check -- for cat
IFS=$IFS'@█' # for spliting config file # bb-w32 supports only ascii?

[ -r "$o.conf" ] && colors=$(grep -v '^#' "$XDG_HOME_DIR/lolcat.sh/lolcat-line.cache")

colors=$( printf %s "$colors" | tr -s "$IFS" ' ' ) # fix epty color
line_x=0

set -f

line_i=0;
while :; do

	set -- $colors
	: "$(( line_i = ( ( line_i + 9 ) % $#  )+1 ))"
	shift "$line_i"


	read -r line
	line_x=$? # eXit code for reading line

	i=1
	c=1
	while [ "$i" -le "${#line}" ]; do
		eval "printf '%s%c' \"\${$(( ( i % $# )+1 ))}\" \"\$c\""

		: "$(( i = i + 1 ))"
	done


	if [ "$line_x" -eq 0 ]; then
		printf '\33[m\n'
	else
		printf '\33[m'
		break
	fi
done
