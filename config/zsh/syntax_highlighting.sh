typeset -r zsh_synt_highlight="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [[ -f "$zsh_synt_highlight" ]]
then
	. "$zsh_synt_highlight"

	# Set comment style to gray
	ZSH_HIGHLIGHT_STYLES[comment]="fg=#a0a0a0"
fi
