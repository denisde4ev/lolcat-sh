#!/bin/sh
set -eu


o=${0##*[/\\]} # for busybox-w32
#o=${0%.sh} # todo trim *".sh"

# todo check -- for cat
IFS=$IFS'@█' # for spliting config file # bb-w32 supports only ascii?

[ -r "$o.conf" ] && colors=$(grep -v '^#' "$o.conf") || \
colors=$(grep -v '^#' -- "${XDG_CONFIG_HOME:-"$HOME/.config"}/$o/$o.conf") || \
colors=$(grep -v '^#' -- "${XDG_CONFIG_HOME:-"$HOME/.config"}/lolcat.sh/lolcat.cat.conf")
#echo "${colors//[$IFS]/@}"

colors=$( printf %s "$colors" | tr -s "$IFS" ' ' ) # fix epty color
line_x=0

set -f

line_i=0;
while :; do

	set -- $colors
	#printf '%b1\33[m\n' "$@" 
	: "$(( line_i = ( line_i + 5 ) % $# ))"
	# echo "$(( ( line_i + 5 ) )) % $(( ( $# * 2 ) ))"
	shift "$line_i"



	read -r line || line_x=$? # eXit code for reading line

	i=1 # wtf , starts with 1
	while [ "$i" -le "${#line}" ]; do
		c=$(expr substr "$line" "$i" 1) || [ "$c" != '' ] || break # wtf, expr substr for '0' (zero, '0'!='\0') char returns exit code 1 ....
		printf "%s%c" "$1" "$c"


		shift && [ 1 -lt $# ] || set -- $colors # TODO: problem when not end file reseted
		: "$(( i = i + 1 ))"
	done







	if [ "$line_x" -eq 0 ]; then
		printf '\33[m\n' # just 1 \n
	else
		printf '\33[m'
		break
	fi
done
