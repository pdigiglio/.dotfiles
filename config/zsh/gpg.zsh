# Let gpg-agent emulate ssh-agent.
# See: https://wiki.archlinux.org/title/GnuPG#SSH_agent
#
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]
then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# NOTE
#
# The line below, initializes GPG_TTY to "not a tty":
#
# export GPG_TTY=$(tty)
#
# This due to Powerlevel10k. See: https://unix.stackexchange.com/a/608921
# Here's the fix on zsh ($TTY is set by zsh early on initization).
export GPG_TTY=$TTY
gpg-connect-agent updatestartuptty /bye >/dev/null

# TIP: When using multiple terminals, to enter the password via pinentry-curses
# from the same terminal where ssh was invoked, add this to ~/.ssh/config:
#
#   Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
#
# See: https://wiki.archlinux.org/title/GnuPG#Configure_pinentry_to_use_the_correct_TTY
