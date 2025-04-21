#!/bin/bash
# Runnable config for bash

# Source global definitions
[ -r /etc/bashrc ] && source /etc/bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source shell shared things
for file in ~/.shell/{path,exports,aliases,profile}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Ignore commands that have either leading whitespace or are duplicates
HISTCONTROL=ignoreboth

# Increase history size
HISTSIZE=5000

# Append to history file instead of overwrite
shopt -s histappend

# Check window size after each command and update LINES and COLUMNS acordingly
shopt -s checkwinsize

# Allow recursive matching with `**` (e.g. dir/**/*.ext expands to dir/*.ext, dir/*/*.ext, dir/*/*/*.ext etc.)
shopt -s globstar

# Match case-insensitive on filename expansion
shopt -s nocaseglob;

# Autocorrect minor typos on `cd`-ing
shopt -s cdspell;

# cd into directory by just enter directory name (e.g. `Music` expands to `cd ./Music`)
shopt -s autocd

# Basic tab completion
if [ "$(uname)" == 'Darwin' ]; then
    [ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Make Tab autocomplete regardless of filename case
bind "set completion-ignore-case on"

# List all matches in case multiple possible completions are possible
bind "set show-all-if-ambiguous on"

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# Show all autocomplete results at once
bind "set page-completions off"

# If there are more than 200 possible completions for a word, ask to show them all
bind "set completion-query-items 200"

# Show extra file information when completing, like `ls -F` does
bind "set visible-stats on"

# Be more intelligent when autocompleting by also looking at the text after the cursor
bind "set skip-completed-text on"

# Allow UTF-8 input and output
bind "set input-meta on"
bind "set output-meta on"
bind "set convert-meta off"

# Setup a very basic prompt
PS1="\h:\W \u\$ "

# Setup fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Setup cargo
[ -f ~/.cargo.env ] && source ~/.cargo.env
