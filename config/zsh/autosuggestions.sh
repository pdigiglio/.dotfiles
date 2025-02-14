typeset -r zsh_autosuggestions="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -f "$zsh_autosuggestions" ]]
then
	. "$zsh_autosuggestions"

	# <C-Space> accepts suggestion.
	bindkey '^ ' autosuggest-accept

	# Set comment style to gray
	#ZSH_HIGHLIGHT_STYLES[comment]="fg=#a0a0a0"
fi
