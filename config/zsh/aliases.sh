# Check if an utility exists; i.e. if it can be called from the cmd line. The
# exit code is success, if the utility exists.
#
# @param $1 The utility name
function utility_exists() {
    typeset -r utility="$1"
    which "$1" > /dev/null
}

alias ls="ls --color=auto "
alias grep="grep --color=auto "
alias vim="nvim "

utility_exists ip && alias ip='ip --color=auto '
