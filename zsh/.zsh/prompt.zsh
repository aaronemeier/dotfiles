# Minimal prompt for zsh

prompt_git(){
    local ref="$vcs_info_msg_0_"
    if [[ -n "$ref" ]]; then
        if $(test -n "$(git status --porcelain --ignore-submodules)"); then
            ref="${ref} \u2605"
        else
            ref="${ref} "
        fi
        if [[ "${ref/.../}" == "$ref" ]]; then
            ref="\ue0a0 $ref"
        else
            ref="\u27a6 ${ref/.../}"
        fi
        print -n "%F{yellow}% $ref %f"
    fi
}

prompt_main() { print -n "\n %(?.%F{green}.%F{red}) \u279c %f " }

prompt_virtualenv(){
     [[ -n $VIRTUAL_ENV ]] && print -n "\U1f40d %F{cyan}% $(basename $VIRTUAL_ENV) %f " 
}

prompt_user(){
    [[ "$USER" != "$ZSH_PROMPT_DEFAULT_USERNAME" ]] && print -n "%F{cyan}% $USERNAME %f \U1f449 "
}

prompt_precmd() {
    vcs_info
    # Update title
    print -nP "\e]0;$PWD\a"
	PROMPT=' $(prompt_user)%F{blue}%~ $(prompt_git)$(prompt_virtualenv)$(prompt_main) %'
}

prompt_setup() {
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    # Prevent percentage showing up
    export PROMPT_EOL_MARK=''

    # Borrowed from promptinit, sets the prompt options in case the prompt was not
    # initialized via promptinit.
    prompt_opts=(cr percent sp subst)
    setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

    add-zsh-hook precmd prompt_precmd

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes false
    zstyle ':vcs_info:git*' formats '%b'
    zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_setup "$@"
