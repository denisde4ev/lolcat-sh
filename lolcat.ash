#!/bin/bash

# ===  supported shels:  ===
# yash: ??
# dash: no
# ash: not done
# bash: yes
# zsh: yes
# mksh: ?? # ${@:1:1} is not as expected

set -euf

o=${0##*/}
#o=${0%.sh} # todo trim *".sh"

# todo check -- for cat
IFS=$IFS'@█' # for spliting config file # bb-w32 supports only ascii?

[ "$1" != '' ] && colors=$( grep -v '^#' "$1" | tr -s "$IFS" ' ' )
#colors_len=${#colors[@]}

line_x=0


line_i=0


TODO NOT DOTE: detect offsets '(ash expected to be i*2-2)'
# TODO:
# detect offsets (ash expected to be i*2-2)
{
	set -- qgm dst
	shoff_i=''
	shoff_mul=''
	for i in 0 1 2 3 4 5; do
		if [ qgm = "${@:1+i:1}" ]; then
			echo shoff_i is $i
			shoff_i=$i
			for i in 0 1 2 3 4 5; do
				if [ dst = "${@:2*i+shoff_i:1}" ]; then
					echo shoff_mul is $i
					shoff_mul=$i
					break
				fi
			done
			break
		fi
	done
	[ "$shoff_i" != '' ] && [ "$shoff_i" != '' ] || {
		echo >&2 could not detect argument offset fer shell interpretator
		exit 1
	}
}
set -- $colors


while :; do

	#set -- $colors
	##printf '%b1\33[m\n' "$@" 
	#: "$(( line_i = ( line_i + 5 ) % $# ))"
	# echo "$(( ( line_i + 5 ) )) % $(( ( $# * 2 ) ))"
	#shift "$line_i"


	
	#shift 5 && (( $# != 0 )) || { j=$(( 5 - $# )); set -- $colors && shift "$j"; }



	read -r line || line_x=$? # eXit code for reading line

	liner='' # line result
	#i=1 # wtf , starts with 1
	for (( i=0; i<${#line}; i++ )); do
		#c=$(expr substr "$line" "$i" 1) || [ "$c" != '' ] || break # wtf, expr substr for '0' (zero, '0'!='\0') char returns exit code 1 ....
		#c=
		#j=$(( ( i %colors_len ) +1 ))
		printf -v v "%s%c" "${colors[(i + line_i) %colors_len]}" "${line:$i:1}"
		liner=$liner$v

		## shift && [ 1 -lt $# ] || set -- $colors # TODO: problem when not end file reseted
		# : "$(( i = i + 1 ))"
	done
	printf %s "$liner"
	(( line_i+=1 ))






	if [ "$line_x" -eq 0 ]; then
		printf '\33[m\n'
	else
		break
		printf '\33[m'
	fi
done
