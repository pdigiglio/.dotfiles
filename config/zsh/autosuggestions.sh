# Different OSs put zsh plugins in different folders.  Look in more than one
# folder and load the first one that's found.
for zsh_autosuggestions in /usr/share/{zsh/plugins/,}zsh-autosuggestions/zsh-autosuggestions.zsh
do
    [[ -f "$zsh_autosuggestions" ]] || continue

    . "$zsh_autosuggestions"

    # <C-Space> accepts suggestion.
    # (I also use <C-Space> as kitty prefix)
    # bindkey '^ ' autosuggest-accept
    break
done
