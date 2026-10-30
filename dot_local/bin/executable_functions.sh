#!/usr/bin/env bash

mpv() {
  set -x
  _c_() {
    command mpv "$1"
  }

  _d_() {
    local arg="$1"

    if [[ -f "${arg:=$PWD}" ]]; then
      command mpv "$arg"
    elif [[ "$arg" =~ ^http ]]; then
      command mpv "$arg"
    elif [[ -d "$arg" ]]; then
      file=$(find "$arg" -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' -o -iname '*.webm' -o -iname '*.flv' -o -iname '*.wmv' -o -iname '*.m4v' -o -iname '*.mpeg' -o -iname '*.mpg' -o -iname '*.m3u' \) | sort | fzf)
    else
      file="$(find "$HOME" -type d -iname "*$arg*" | xargs -I {} find {} -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' -o -iname '*.webm' -o -iname '*.flv' -o -iname '*.wmv' -o -iname '*.m4v' -o -iname '*.mpeg' -o -iname '*.mpg' -o -iname '*.m3u' \) | sort | uniq | fzf)"
    fi
    command mpv "$file"
  }

  while getopts ":c:d:" opts; do
    case "$opts" in
    c) _c_ "$OPTARG" ;;
    d) _d_ "$OPTARG" ;;
    :) printf "Error: Option -%s needs an argument" "$OPTARG" >&2 ;;
    \?) printf "Error: Option -%s in an invalid option" "$OPTARG" >&2 ;;
    esac
  done
  shift $((OPTIND - 1))

  _d_ "$1"

  set +x
}
