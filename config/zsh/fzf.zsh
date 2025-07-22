. "$ZDOTDIR/utils.sh"

# Check if fzf is installed
utility_exists fzf || return

# Set up fzf key bindings and fuzzy completion
. <(fzf --zsh)

# Make history search with '/' and '?' interactive. Unlike the built-in binds,
# they'll search in the same direaction.
bindkey -M vicmd '/' fzf-history-widget
bindkey -M vicmd '?' fzf-history-widget

# Check if the fzf/git integration is available.
if [ -f "$ZDOTDIR/fzf-git.sh" ]
then
    # Source the file.
    . "$ZDOTDIR/fzf-git.sh"

    # As I have KEYTIMEOUT=1, the default keybindings (i.e. <C-g><C-b> for
    # branches) won't work. I remap them here:
    bindkey '\eb' fzf-git-branches-widget
    bindkey '\ee' fzf-git-each_ref-widget
    bindkey '\ef' fzf-git-files-widget
    bindkey '\eh' fzf-git-hashes-widget
    bindkey '\el' fzf-git-lreflogs-widget
    bindkey '\er' fzf-git-remotes-widget
    bindkey '\es' fzf-git-stashes-widget
    bindkey '\et' fzf-git-tags-widget
    bindkey '\ew' fzf-git-worktrees-widget
    # NOTE: some of these mappings conflict with my media keys (e.g. <A-l>).
fi
