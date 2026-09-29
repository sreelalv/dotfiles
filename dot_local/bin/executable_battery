#!/usr/bin/env bash

status="$(upower -i $(upower -e | awk 'NR==1 {print}') | grep state | awk '{print $2}')"
percentage="$(upower -i $(upower -e | awk 'NR==1 { print }') | grep percentage | awk '{print $2}' | cut -d'%' -f1)"

if [[ "$status" = "discharging" && "$percentage" -lt 20 ]]; then
  notify-send -u critical "Battery  Low !" || wall "Battery Low!"
  while [ "$(upower -i $(upower -e | awk 'NR==1 {print}') | grep state | awk '{print $2}')" = "discharging" ]; do
    paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
    sleep 1
  done
fi
