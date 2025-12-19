# Different OSs put zsh plugins in different folders.  Look in more than one
# folder and load the first one that's found.
for zsh_synt_highlight in /usr/share/{zsh/plugins/,}zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
    [[ -f "$zsh_synt_highlight" ]] || continue

    . "$zsh_synt_highlight"

    # Set comment style to gray
    ZSH_HIGHLIGHT_STYLES[comment]="fg=#a0a0a0"
    break
done
