#!/bin/bash

background(){
	if [[ "$@" =~ .*sudo.* ||  "$@" =~ .*yay.* ]] ; then 
		sudo ls >/dev/null 2>&1 
	fi
	(( "$@" >/dev/null 2>&1 && [[ $? -eq 0 ]] && (notify-send "Task Completed" "$*") || (notify-send "Task Failed" "$*") )&)
	[[ $? == 0 ]] && echo "Background : $@" 
}

quiet(){
	("$@" >/dev/null 2>&1)
}
