#!/bin/bash


export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enableTouchpad(){
  printf "true" > "$STATUS_FILE"
  notify-send -u low " Enabling" " touchpad "
  hyprctl keyword 'device[elan1203:00-04f3:307a-touchpad]:enabled' true
}


disableTouchpad(){
  printf "false" > "$STATUS_FILE"
  notify-send -u low " Disabling" " touchpad "
  hyprctl keyword 'device[elan1203:00-04f3:307a-touchpad]:enabled' false
}

if ! [ -f "$STATUS_FILE" ]; then
  disableTouchpad
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disableTouchpad
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enableTouchpad
  fi
fi
