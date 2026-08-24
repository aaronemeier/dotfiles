#!/bin/bash
# Toggles the mute flag for the Generals voice-line hooks and prints the new state
flag="$HOME/.claude/hooks/generals-sounds/.muted"
if [ -f "$flag" ]; then
  rm "$flag"
  echo "STATE: voice lines UNMUTED"
else
  touch "$flag"
  echo "STATE: voice lines MUTED"
fi
