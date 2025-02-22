# Check if an utility exists; i.e. if it can be called from the cmd line. The
# exit code is success, if the utility exists.
#
# @param $1 The utility name
function utility_exists() {
    typeset -r utility="$1"
    which "$1" > /dev/null
}

# Make sure user-defined aliases work when using sudo.
# See: https://stackoverflow.com/q/37209913
alias sudo='sudo '
alias ls='ls --color=auto --hyperlink=auto '
alias grep="grep --color=auto "
#alias vim="nvim "


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
