. "$zdot_dir"/utils.sh

# Check if fzf is installed
utility_exists fzf || return

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
