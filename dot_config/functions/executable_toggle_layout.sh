#!/usr/bin/env bash

set -e 

declare -a layout=(dwindle master scrolling)
nl="${#layout[@]}"
echo "$nl"
current_layout=$(hyprctl -j activeworkspace | jq '.tiledLayout' | cut -d '"' -f 2)
change_layout(){
	for i in "${!layout[@]}" ; do
		if [[ "$current_layout" = "${layout[$i]}" ]] ;then 
			i="$(( (i+1) % nl))" 
			ws="$(hyprctl -j activeworkspace | jq '.id')"
			hyprctl keyword workspace "$ws", "layout:${layout[i]}"
			notify-send "Layout Changed" "${layout[$i]}"
		fi
	done
}
change_layout
