#!/usr/bin/env bash

if [[ -f /tmp/focusModeTimer ]] ; then 
	tar_time=$(cat /tmp/focusModeTimer )
fi
if [[ -n "$tar_time" ]]; then 
	cur_time=$(date +'%H:%M:%S')

	t_diff="$(( $(date -d "$tar_time" +%s) - $(date -d "$cur_time" +%s) ))"
	t_diff="$(printf '%02d:%02d:%02d\n' $((t_diff/3600)) $((t_diff%3600/60)) $((t_diff%60)) )"
fi
dnd_status=$(swaync-client -D) 
if [[ $dnd_status == true ]]  ; then 
	if [[ -n "$t_diff" ]] ; then
		printf '{ "text" : "%s", "class" : "dnd-on" }' " $t_diff"
	else
		echo '{ "text" : "", "class" : "dnd-on" }' 
	fi
else
	echo '{ "class" : "dnd-off" }'
fi



unset tar_time
unset dnd_status
