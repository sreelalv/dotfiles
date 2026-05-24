#!/usr/bin/env bash 

yt-mpv(){
    local mpv_entry="$(zenity --forms --title='mpv' --text='' --add-entry='Paste the link' --add-entry='Name')"
    IFS='|' read -r url comment <<< $mpv_entry
    if ! [[ -n "url" ]] ; then 
        return
    else
        if [[ -n "$comment" ]]; then 
            printf "%s|%s" "$comment" "$url" >> $HOME/.config/mpv/mpv_history
        fi
        mpv "$url"
    fi
}
yt-mpv
