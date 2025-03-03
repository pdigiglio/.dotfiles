# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%F{yellow}%b%f) '

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

function last_error_code() {
    typeset -r error=$?
    [[ "$error" == "0" ]] || echo "%F{red}${error}%f|"
}

PROMPT='$(last_error_code)%F{#009070}%~%f ${vcs_info_msg_0_}%# '
#RPROMPT='[%F{yellow}%?%f]'
