#!/bin/bash

dire="$HOME/Pictures/Screenshots"
tmpfile="$(mktemp)"
grim -g "$(slurp)" - >"$tmpfile"

# Copy with saving
if [[ -s "$tmpfile" ]]; then
	wl-copy <"$tmpfile"
	f_name="$(zenity --entry)"
	if [[ "$?" == "0" ]] ; then 
		while [[ $(ls "$dire" | grep -i -E  "^${f_name}.png$") ]] ; do 
			f_name="$(zenity --entry --text="File already exist")"
		done
		if [[ -z "$f_name" ]] ; then 
			f_name="$(date +'%I:%M:%S%p')"
		else
			f_name="$f_name.png"
		fi
			mv "$tmpfile" "$dire/$f_name"
	fi
fi
