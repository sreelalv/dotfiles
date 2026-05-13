#!/usr/bin/env bash

tt(){
	if [[ "$#" == 0 ]] ; then 
		tmux
		return 
	fi
	local arg="$1"
	local list=( $(tmux ls 2>/dev/null| awk -F':' '{print $1}' ) )
	for i in "${list[@]}" ; do 
		if [[ "$arg" = "$i" ]] ;then 
			tmux attach -t "$i" 
			return
		fi
	done
	if [[ "$1" =~ "ls" ]] ; then
		tmux ls
	elif [[ "$1" =~ ^[Aa]([Tt]([Tt]([Aa]([Cc]([Hh]?)?)?)?)?)? || "$1" =~ ^[Aa]$ ]]  ; then 
		tmux attach 
	else
		tmux new -s "$arg"
	fi
}


