# Improve run-help in Zsh (which defaults to an alias to man).
# See: https://wiki.archlinux.org/title/Zsh#Help_command

autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help
alias help='run-help '

# NOTE: these don't seem to work on:
# zsh 5.9 (x86_64-pc-linux-gnu)

# autoload -Uz run-help-btrfs
# autoload -Uz run-help-git
# autoload -Uz run-help-ip
# autoload -Uz run-help-openssl
# autoload -Uz run-help-p4
# autoload -Uz run-help-sudo
# autoload -Uz run-help-svk
# autoload -Uz run-help-svn
