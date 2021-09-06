#!/bin/sh
set -euf


o=${0##*[/\\]} # for busybox-w32
#o=${0%.sh} # todo trim *".sh"

# todo check -- for cat
IFS=$IFS'@█' # for spliting config file # bb-w32 supports only ascii?

{ [ "${1:-}" != '' ] && colors=$(grep -v '^#' -- "$1"     ); } || \
{ [ -r "$o.conf"   ] && colors=$(grep -v '^#' -- "$o.conf"); } || \
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
	: "$(( line_i = ( line_i + 1 ) % $# ))"
	# echo "$(( ( line_i + 5 ) )) % $(( ( $# * 2 ) ))"
	shift "$line_i"



	read -r line || line_x=$? # eXit code for reading line

	#i=1 # wtf , starts with 1
	## line var will be destroyed
	while [ "$line" != "" ]; do
		next=${line#?}
		printf "%s%c" "$1" "${line%"$next"}"
		line=$next

		shift && [ 1 -lt $# ] || set -- $colors # TODO: problem when not end file reseted
	#	: "$(( i = i + 1 ))"
	done







	if [ "$line_x" -eq 0 ]; then
		printf '\33[m\n' # just 1 \n
	else
		printf '\33[m'
		break
	fi
done
