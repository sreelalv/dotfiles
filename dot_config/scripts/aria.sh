#!/usr/bin/env bash


__target_parser__(){
	local tar="$1"
	local output="$(echo $tar | cut -d'=' -f2)"
	printf "%s" "$output"
}

ariadir(){
	local path="$HOME/.config/.aria_path"
	if [[ -n "$1" ]] ; then 
		if [[ $(command -v realpath) ]] ; then 
			realpath $1 |tee $path
		else
			echo "Realpath : command not found"
		fi
	else
		if [[ -f $path ]]; then 
			cat $HOME/.config/.aria_path
		else
			echo "$HOME/Downloads/aria"
		fi
	fi
}
aria(){
	local -a flags=("$@")
	local full_args="${flags[@]}"
	local dir=""
	if [[ -f "$HOME/.config/.aria_path" ]] ; then 
		read dir < "$HOME/.config/.aria_path"
		dir="-d ${dir}"
	else
		local dir="-d $HOME/Downloads/aria/"
	fi

	local _aria_="aria2c -x 16 -s 16 -j 8"
	local con="--continue=true" 
	local overwrite="--allow-overwrite"
	local torrent="--enable-dht=true --bt-enable-lpd=true --bt-max-peers=50 --seed-time=0"
	local message=""
	local exit_flag=1

	local input="${flags[0]}"
	if [[ $input =~ torrent$ || $input =~ ^magnet ]] ; then
		_aria_="${_aria_} ${torrent}"
	fi

	for (( i = 1 ; i < "${#flags[@]}" ; i++ )) ; do 
		fg="${flags[i]}"
		target=""
		case $fg in 
			-d=*) 
				target=$(__target_parser__ "$fg")
				[[ -d "$target" ]] && dir="-d $target"
				;; 
			-m=* )
				message=$(__target_parser__ "$fg")
				;;
			-o | -over* ) 
				_aria_="${_aria_} ${overwrite}"	
				;; 
			-c | -cont* ) 
				_aria_="${_aria_} ${con}"
				;; 
			-nx | --no-exit )
				exit_flag=0
				;;
		esac			
	done
	_aria_="${_aria_} ${dir}"
	$_aria_ "$input"
	local status="$?"
	if [[ "$status" == 0 && -n "$message" ]] ; then 
		notify-send "Download Complete" "$message"
	fi
	if [[ $exit_flag == 1 ]] ; then 
		exit "$status" 
	fi 
}

