#!/usr/bin/env bash

bl()(        #Bluetooth control 
	if [[ "$(rfkill | grep bluetooth | awk '{print $4}' | grep blocked)" = "blocked" ]] ; then
		if ! [[ "$1" = "enable" || "$1" = "-h" ||  "$1" = "--help" ||"$1" = "--help" || "$1" = "i" || "$1" = "interactive" ]] ; then 
			printf "Bluetooth is blocked\n"
			printf "bl enable - to unblock\n"
			return
		fi
	fi

	if [[ "$(bluetoothctl show | grep PowerState | grep off)" ]] ; then 
		quiet bluetoothctl power on
	fi

	local param1="$1"
	local param2="$2"
	local tmpfile="/tmp/tmp.bluetoothdevices"

	if [[ ! -f "$tmpfile" ]] ; then 
		touch "$tmpfile"
		param1="*"
	fi

	if [[ "${param1}" =~ [0-9]$ ]] ; then 
		param2="$param1"
		param1="con"
	fi 

	declare -A bl_list 
	while read -r  key value ; do 
		bl_list["$key"]="$value"
	done < <(awk '{print $1,$3}' "$tmpfile")

	case $param1 in 
		interactive | i )
			bluetoothctl 
			;;

		scan )
			((expect -c '
				spawn bluetoothctl 
				set timeout 0
				expect "#"
				send "scan on\r"
				set timeout 5
				expect "#"
				send "exit\r"
				' >/dev/null 2>&1)&& bl )
				;;

		connected )
			for i in ${!bl_list[@]} ; do 
				if [[ "$(bluetoothctl info ${bl_list["$i"]} | grep Connected | grep yes)" ]] ; then 
					bluetoothctl devices | grep --colour=never "${bl_list["$i"]}" 
				fi
			done
			;; 

		con )

			if [[ -z "$param2" ]] ; then 
				echo "No device found" 
			else
				if [[ "$(bluetoothctl info ${bl_list[$param2]} | grep Trusted | awk '{print $2}')" == "no" ]] ;then
					quiet bluetoothctl pair "${bl_list[$param2]}"
					quiet bluetoothctl trust "${bl_list[$param2]}" 
				fi
				quiet bluetoothctl connect "${bl_list[$param2]}"
				if [[ "$(bluetoothctl devices Connected | grep ${bl_list[$param2]}))" ]] ; then 
					echo "Connection Successfull"
				fi 
			fi
			;; 

		dis | disconnect) 
			if [[ -z $param2 ]] ; then 
				quiet bluetoothctl disconnect 
			else
				echo "Disconnecting ${bl_list["$param2"]}..." 
				quiet bluetoothctl disconnect ${bl_list["$param2"]}
			fi
			;;

		rm | remove )
			if [[ -z "$param2" ]] ; then 
				for i in ${bl_list[@]} ; do 
					echo "Removing $i"
					quiet bluetoothctl remove "$i"
				done
			else
				echo "R2 ${bl_list["$param2"]}"
				quiet bluetoothctl remove "${bl_list["$param2"]}" 
			fi
			;; 

		disable)
			rfkill block bluetooth
			;;

		enable)
			rfkill unblock bluetooth
			;;

		-h | --help )
			printf "\t bl <i|interactive> - bluetoothctl interactive\n"
			printf "\t bl \t\t- List available devices \n"
			printf "\t bl scan \t- Scan for new devices\n"
			printf "\t bl connected \t- Show connected devices\n"
			printf "\t bl con <id> \t- Connect to device <id> \n"
			printf "\t bl dis \t- Disconnect current device\n"
			printf "\t bl dis <id> \t- Disconnected device <id> \n"
			printf "\t bl rm <id> \t- Remove/Forget device <id> \n"
			printf "\t bl rm \t\t- Remove/Forget devices recursively (all) \n"
			printf "\t bl enable \t- Enable bluetooth (rfkill unblock bluetooth) \n"
			printf "\t bl disable \t- Disable bluetooth (rfkill block bluetooth) \n" 
			;;


		* )
			bluetoothctl devices | grep --colour=never Device | awk 'BEGIN{i=1}{print i" "$0 ;i++}' | tee  $tmpfile
			;; 

	esac
	return 0
)

