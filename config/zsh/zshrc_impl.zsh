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
#
#  * https://thevaluable.dev/zsh-install-configure-mouseless/
#
#  * Options (i.e. `setopt`) are described at: man 1 zshoptions. They're case
#  insensitive and underscores are ignored.

# $zdot_dir defined in wrapping zshrc file.

# Lines configured by zsh-newuser-install
# See: man zshall
HISTFILE="$XDG_STATE_HOME/zsh/histfile"
HISTSIZE=1000
SAVEHIST=1000

# Do not enter command lines into the history list if they are duplicates of
# the previous event.
setopt HIST_IGNORE_DUPS

# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading
# space.
# 
# Note that the command lingers in the internal history until the next command
# is entered before it vanishes, allowing you to briefly reuse or edit the
# line. If you want to make it vanish right away without entering another
# command, type a space and press return.
setopt HIST_IGNORE_SPACE

setopt autocd
unsetopt beep

bindkey -v

# I don't feel the need for visual line selection. Use 'V' to edit the cmd line
# in an editor instance.
# See: https://unix.stackexchange.com/a/6622
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'V' edit-command-line

# Set <Esc> delay to 0.01s. See zshparam(1).
export KEYTIMEOUT=1

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/pdigiglio/.zshrc'
zstyle :compinstall filename '$zdot_dir/.zshrc'

# End of lines added by compinstall

# -- Allow '#' to comment lines in interactive shell.
setopt INTERACTIVE_COMMENTS

# --

. "$zdot_dir/env.sh"

. "$zdot_dir/aliases.sh"
. "$zdot_dir/autosuggestions.sh"
. "$zdot_dir/cdr.sh"
. "$zdot_dir/completion.zsh"
. "$zdot_dir/fzf.zsh"
. "$zdot_dir/gpg.sh"
. "$zdot_dir/run_help.sh"

# This file sources and sets up "zsh-syntax-highlighting". Source it last, as
# explained in:
# https://github.com/zsh-users/zsh-syntax-highlighting?tab=readme-ov-file#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
. "$zdot_dir/syntax_highlighting.sh"
