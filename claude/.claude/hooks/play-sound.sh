#!/bin/bash
# Plays a random voice line for a category: play-sound.sh <category>
[ -f "$HOME/.claude/hooks/generals-sounds/.muted" ] && exit 0
files=("$HOME/.claude/hooks/generals-sounds/$1"/*.mp3)
[ -e "${files[0]}" ] || exit 0
afplay "${files[RANDOM % ${#files[@]}]}" >/dev/null 2>&1 &
exit 0
