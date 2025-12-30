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

# --
# Set vi-like bindings for the command line.
#
# NOTE: I set this early because this wouls discard any previous `bindkey`
# command 
bindkey -v

# I don't feel the need for visual line selection. Use 'V' to edit the cmd line
# in an editor instance.
#
# See: https://unix.stackexchange.com/a/6622
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'V' edit-command-line

# When searching in the history with 'k', only commands matching the current
# line up to the current cursor position will be shown.
#
# NOTE: The "current" cursor position is the one _before_ the cursor.  This
# means you'll lose a char in normal mode; i.e. you won't be able to use the
# last char for filtering as well.
#
# If you don't want that, use the arrows (both in normal and insert mode)
#
# See: https://wiki.archlinux.org/title/Zsh#History_search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M vicmd 'k'   up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# Set <Esc> delay to 0.01s. See zshparam(1).
export KEYTIMEOUT=1
# --

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

# This option:
#
#  - imports new commands from the history file,
#  - causes your typed commands to be appended to the history file (this is
#  like specifying INC_APPEND_HISTORY)
#
# The history lines are also output with timestamps ala EXTENDED_HISTORY.
#
# By default, history movement commands visit the imported lines and the local
# lines. You can toggle this with the set-local-history zle binding. It is also
# possible to create a zle widget that will make some commands ignore imported
# commands, and some include them.
setopt SHARE_HISTORY

# <Up> and <Down> give me the prev/last command that starts with what I typed
# in the command line. Very useful with autosuggestion plugin.
#
# To get the key code for special keys:
#
#  * Open a terminal
#  * Press Ctrl-V
#  * Press the key
#
# The key code will be displayed on the command line.
#
# See: https://stackoverflow.com/a/14041933
#
# The thread also mentions the '!<pattern>' and '!?<pattern>' tricks.
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

setopt autocd
unsetopt beep

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/pdigiglio/.zshrc'
zstyle :compinstall filename '$ZDOTDIR/.zshrc'

# End of lines added by compinstall

# -- Allow '#' to comment lines in interactive shell.
setopt INTERACTIVE_COMMENTS

# By default, zsh will still own the processes it runs in background. So
# exiting the shell will terminate the background child processes. I don't like
# this behavior.
#
# NOTE: you can also disown background processes with &! or &|.
#
# See: https://stackoverflow.com/a/33735937
setopt NO_HUP

# --

. "$ZDOTDIR/env.after.sh"
. "$ZDOTDIR/utils.sh"

. "$ZDOTDIR/aliases.sh"
. "$ZDOTDIR/autosuggestions.sh"
. "$ZDOTDIR/cdr.sh"
. "$ZDOTDIR/completion.zsh"
. "$ZDOTDIR/fzf.zsh"
. "$ZDOTDIR/gpg.zsh"
. "$ZDOTDIR/run_help.sh"
. "$ZDOTDIR/uv.zsh"


. "$XDG_CONFIG_HOME/Unreal Engine/aliases.sh"

# This file sources and sets up "zsh-syntax-highlighting". Source it last, as
# explained in:
# https://github.com/zsh-users/zsh-syntax-highlighting?tab=readme-ov-file#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
. "$ZDOTDIR/syntax_highlighting.sh"
