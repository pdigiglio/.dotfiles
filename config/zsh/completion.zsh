# Arrow-driven completion
zstyle ':completion:*' menu select

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz compinit

# Add my custom completions. Do this before calling compinit.
fpath=("$ZDOTDIR/completions" $fpath)

typeset -r zsh_cache_dir="$XDG_CACHE_HOME"/zsh
mkdir --parents "$zsh_cache_dir"
zstyle ':completion:*' cache-path "$zsh_cache_dir"/zcompcache
compinit -d "$zsh_cache_dir"/zcompdump-$ZSH_VERSION

# Complete to the longest unambiguous prefix and show completion menu (if still
# ambiguous). See: https://unix.stackexchange.com/a/295712
setopt nolistambiguous
