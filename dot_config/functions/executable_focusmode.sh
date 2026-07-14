#!/usr/bin/env bash 

cleanup(){
	unset f_time
	unset tar_time
	kill -9 "$sl_pid" >/dev/null 2>&1
	unset sl_pid
	echo "Removing /tmp/focusModeTimer"
	rm -f /tmp/focusModeTimer
}

trap cleanup SIGINT SIGTERM EXIT

f_mod(){
	if ! [[ "$f_time" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then 
		notify-send "$f_time Not a Number" 
		exit
	fi

	swaync-client -dn 
	
	tar_time=$(date +"%H:%M:%S" -d "+$f_time minutes") 	
	echo "$tar_time" > /tmp/focusModeTimer
	sleep "$((f_time * 60 ))" & 
	sl_pid=$!
	wait "$sl_pid"

	swaync-client -df
	notify-send "TIMEUP!"
	paplay 	"/usr/share/sounds/freedesktop/stereo/message.oga"
	
}



if [[ -f /tmp/focusModeTimer ]] ; then
	ps aux | grep "focusmode.sh" | grep bash | awk '{print $2}' | xargs kill -15 
else
	touch /tmp/focusModeTimer
	f_time="$(zenity --entry --text='Enter time in Minutes!' 2>/dev/null)"
	f_mod
fi
