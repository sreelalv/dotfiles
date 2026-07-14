#!/bin/bash


dir="$HOME/Pictures/Wallpapers"
choice=$(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | 
         while read img; do echo -en "$img\0icon\x1f$img\n"; done | 
         rofi -dmenu -i -p "Select Wallpaper " -theme $HOME/.config/rofi/wallpaper.rasi )

[ -n "$choice" ] && ln -sf "$choice" "$dir/.current_wallpaper" && pkill hyprpaper && ((hyprpaper >/dev/null 2>&1)&) 

if [[ $? == 0 ]] ;then 
	if [[ -e "$dir/.lockscreen" ]]; then
		zenity --question --text="Do you want to set this as lockescreen wallpaper" && [ -n "$choice" ] && ln -sf "$choice" "$dir/.lockscreen" 
	else
		[ -n "$choice" ] && ln -sf "$choice" "$dir/.lockscreen" 
	fi
fi
