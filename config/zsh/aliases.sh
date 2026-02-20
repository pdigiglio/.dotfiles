. "$ZDOTDIR/utils.sh"

# Make sure user-defined aliases work when using sudo.
# See: https://stackoverflow.com/q/37209913
alias sudo='sudo '

# Use LS_COLORS to highlight orphan symlinks in red.
alias ls='LS_COLORS="or=31" ls --color=auto --hyperlink=auto '
alias grep="grep --color=auto "
#alias vim="nvim "

if utility_exists rsync
then
    alias dirsync='rsync --recursive --itemize-changes --include="*/" --exclude "*" '
fi

utility_exists ip && alias ip='ip --color=auto '

if utility_exists yazi
then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi
