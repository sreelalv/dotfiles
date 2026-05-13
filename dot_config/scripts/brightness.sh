#!/usr/bin/env bash

bri(){        # Brightness control 
	current="$(brightnessctl | awk 'NR==2{print}' | cut -d '(' -f2 | grep -oE [0-9]+)"
	val="$1"

	if [[ -z $val ]] ; then 
		echo "Brightness set $current%" 
	else 
		if [[ "$val" =~ ^[0-9]+$ ]] ;then 
			: 
		elif [[ "$val" =~ ^[+][0-9]+$ ]]; then
			(( val = current + val )) 
		elif [[ "$val" =~ ^[-][0-9]+$ ]]; then 
			val="$(echo $val | tr -d '-')" 
			(( val j= current - val ))  
		fi 
		if [[ $val -lt 5 ]]; then 
			((val = 5))
		fi
		brightnessctl set "$val%" > /dev/null && echo "$(bri)"
	fi
}


