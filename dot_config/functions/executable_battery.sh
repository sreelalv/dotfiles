#!/usr/bin/env bash 


status="$(acpi -b | awk '{print $3}' | tr -d ',')"
percentage="$(acpi -b | awk '{print $4}' | cut -d'%' -f1)"



if [[ "$status" = "Discharging" && "$percentage" -lt 10 ]] ; then
  notify-send -u critical "Battery  Low !"
  while [ "$(acpi -b | awk '{print $3}' | tr -d ',')" = "Discharging" ]
  do 
		paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga 
		sleep 1
  done  
fi
