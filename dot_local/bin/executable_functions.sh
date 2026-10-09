#!/usr/bin/env bash

mpv() {
  local file=""
  if [[ $# == 0 || -d "$1" ]]; then
    if [[ $(command -v realpath) ]]; then
      if [[ $# == 0 ]]; then
        dir=$(realpath "$PWD")
      else
        dir=$(realpath "$1")
      fi
      file="$(find "$dir" -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' -o -iname '*.webm' -o -iname '*.flv' -o -iname '*.wmv' -o -iname '*.m4v' -o -iname '*.mpeg' -o -iname '*.mpg' -o -iname '*.m3u' \) | fzf)"
    fi
  elif [[ "$1" = "-a" || "$1" = "all" || "$1" = "--all" ]]; then
    if [[ $(command -v locate) ]]; then
      file="$(locate -r '.*\.\(mp4\|mkv\|avi\|mov\|webm\|flv\|wmv\|m4v\|mpeg\|mpg\|m3u\)$' | fzf)"
    fi
  else
    if [[ -f "$*" ]]; then
      command mpv "$*"
      exit
    fi
  fi

  if [[ -f "$file" ]]; then
    command mpv "$file"
  fi
}
