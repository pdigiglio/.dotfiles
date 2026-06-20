. "$ZDOTDIR/utils.sh"

# Check if rumdl is installed
utility_exists git-lfs || return

# Set up fzf key bindings and fuzzy completion
. <(git lfs completion zsh)
