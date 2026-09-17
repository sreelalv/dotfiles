#!/usr/bin/env bash

get_clipboard() {
  if [[ -n "${WAYLAND_DISPLAY:-}" ]] && command -v wl-paste >/dev/null 2>&1; then
    wl-paste
  elif [[ -n "${DISPLAY:-}" ]] && command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -o
  elif [[ -n "${DISPLAY:-}" ]] && command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --output
  else
    echo "No supported clipboard utility found." >&2
    return 1
  fi
}

yt-mpv() {
  local mpv_entry

  if ! mpv_entry="$(zenity --forms \
    --title='mpv' \
    --text='' \
    --add-entry='Name')"; then
    return
  fi

  IFS='|' read -r comment <<<"$mpv_entry"

  local url="$(get_clipboard)"

  if [[ -z "$url" ]]; then
    return
  fi

  if [[ -n "$comment" ]]; then
    printf "%s|%s\n" "$comment" "$url" >>"$HOME/.config/mpv/mpv_history"
  fi

  mpv "$url"
}

yt-mpv
