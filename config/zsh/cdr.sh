# Remember recent dirs.
#
# See:
# * https://man.archlinux.org/man/zshcontrib.1#REMEMBERING_RECENT_DIRECTORIES
# * https://github.com/zsh-users/zsh/blob/master/Functions/Chpwd/cdr
#
# To list the recent dirs:  cdr -l
#

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*:*:cdr:*:*' menu selection

# The maximum number of directories to save to the file. If this is zero or
# negative there is no maximum.  The default is 20.
#
# Note this includes the current directory, which isn't offered, so the highest
# number of directories you will be offered is one less than the maximum.
zstyle ':chpwd:*' recent-dirs-max 51

# If true, and the command is expecting a recent directory index, and either
# there is more than one argument or the argument is not an integer, then fall
# through to "cd".
zstyle ':chpwd:*' recent-dirs-default false

# The file where the list of directories is saved.  The default is
# ${ZDOTDIR:-$HOME}/.chpwd-recent-dirs.
zstyle ':chpwd:*' recent-dirs-file  "${XDG_STATE_HOME}"/zsh/chpwd-recent-dirs

# zstyle recent-dirs-file ':chpwd:*' recent-dirs-insert true

#
# Add fzf completion for cdr. To trigger it:
#
#   cdr **<Tab>
#
# This is inspired by the completion fzf offsers for `kill`.
#

_fzf_complete_cdr() {
    _fzf_complete \
        -m \
        --no-preview \
        --wrap \
        --color fg:dim,nth:regular \
        -- "$@" < <(cdr -l)
}

_fzf_complete_cdr_post() {
  __fzf_exec_awk '{print $1}'
}
