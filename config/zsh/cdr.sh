# Remember recent dirs.
# See: https://man.archlinux.org/man/zshcontrib.1#REMEMBERING_RECENT_DIRECTORIES

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*:*:cdr:*:*' menu selection
