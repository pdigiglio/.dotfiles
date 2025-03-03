# Other packages you may want to install:
#
#  * zsh-autosuggestions
#  * zsh-completions
#  * zsh-syntax-highlighting
#  * zsh-theme-powerlevel10k-git
#

#
# TIPS:
#
#  * fc to open the last command in your editor.
#    (See: https://itnext.io/the-zsh-shell-tricks-i-wish-id-known-earlier-ae99e91c53c2)

# $zdot_dir defined in wrapping zshrc file.

# Lines configured by zsh-newuser-install
HISTFILE=~/.local/state/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep

bindkey -v

# Set <Esc> delay to 0.01s. See zshparam(1).
export KEYTIMEOUT=1

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/pdigiglio/.zshrc'
zstyle :compinstall filename '$zdot_dir/.zshrc'

# Arrow-driven completion
zstyle ':completion:*' menu select

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz compinit

# Add my custom completions. Do this before calling compinit.
fpath=("$zdot_dir/completions" $fpath)
compinit

# Complete to the longest unambiguous prefix and show completion menu (if still
# ambiguous). See: https://unix.stackexchange.com/a/295712
setopt nolistambiguous

# End of lines added by compinstall

# -- Allow '#' to comment lines in interactive shell.
setopt INTERACTIVE_COMMENTS

# --

. "$zdot_dir/aliases.sh"
. "$zdot_dir/env.sh"

. "$zdot_dir/autosuggestions.sh"
. "$zdot_dir/cdr.sh"
. "$zdot_dir/gpg.sh"
. "$zdot_dir/run_help.sh"
. "$zdot_dir/syntax_highlighting.sh"
