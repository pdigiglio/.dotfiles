. "$ZDOTDIR/utils.sh"

# Check if rumdl is installed
utility_exists rumdl || return

# Set up fzf key bindings and fuzzy completion
. <(rumdl completions zsh)
