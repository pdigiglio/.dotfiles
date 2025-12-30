. "$ZDOTDIR/utils.sh"

utility_exists uv  && . <(uv    generate-shell-completion zsh)
utility_exists uvx && . <(uvx --generate-shell-completion zsh)
