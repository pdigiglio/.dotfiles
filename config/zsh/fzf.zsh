. "$zdot_dir"/utils.sh

# Check if fzf is installed
utility_exists fzf || return

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Make history search with '/' and '?' interactive. Unlike the built-in binds,
# they'll search in the same direaction.
bindkey -M vicmd '/' fzf-history-widget
bindkey -M vicmd '?' fzf-history-widget
