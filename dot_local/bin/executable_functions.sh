#!/usr/bin/env bash

set -o pipefail

mpv() {
  while getopts "c:" opts; do
    case "$opts" in
    c) command mpv "$OPTARG" && return 0 || return 1 ;;
    :) printf "Error: Option -%s needs an argument" "$OPTARG" >&2 ;;
    \?) printf "Error: Option -%s in an invalid option" "$OPTARG" >&2 ;;
    esac
  done
  shift $((OPTING - 1))

  local file=""
  if [[ $# == 0 || -d "$1" ]]; then
    if [[ $(command -v realpath) ]]; then
      [[ $# == 0 ]] && dir=$(realpath "$PWD") || dir=$(realpath "$1")
      file="$(find "$dir" -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' -o -iname '*.webm' -o -iname '*.flv' -o -iname '*.wmv' -o -iname '*.m4v' -o -iname '*.mpeg' -o -iname '*.mpg' -o -iname '*.m3u' \) | fzf)"
    fi
  elif [[ "$1" = "-a" || "$1" = "all" || "$1" = "--all" ]]; then
    [[ $(command -v locate) ]] && file="$(locate -r '.*\.\(mp4\|mkv\|avi\|mov\|webm\|flv\|wmv\|m4v\|mpeg\|mpg\|m3u\)$' | fzf)"
  else
    if [[ -f "$*" ]]; then
      command mpv "$*"
    elif [[ -d "$*" ]]; then
      file="$(find '$*' -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' -o -iname '*.webm' -o -iname '*.flv' -o -iname '*.wmv' -o -iname '*.m4v' -o -iname '*.mpeg' -o -iname '*.mpg' -o -iname '*.m3u' \) | fzf)"
    else
      file="$(find "$HOME" -type d -iname "*$**" | xargs -I {} find {} -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' -o -iname '*.webm' -o -iname '*.flv' -o -iname '*.wmv' -o -iname '*.m4v' -o -iname '*.mpeg' -o -iname '*.mpg' -o -iname '*.m3u' \) | fzf)"
    fi
  fi

  [[ -f "$file" ]] && command mpv "$file"
}
