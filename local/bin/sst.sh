#!/bin/env bash

# Read a tmux config file and tranform it in such a way that the options in it
# can be passed on the tmux command line invocation.
#
# @param 1  The path to the tmux config file.
function tmux_conf_to_cmd_line() {
	typeset -r tmux_conf="$1"

	sed 's/^\s*#.*//g' "$tmux_conf" |
		grep --invert-match "^\s*$" |
		sed 's/^/ \\; /g' |
		sed 's/%/%%/g' |
		paste --serial --delimiters=" "
}

# Generate the 'RemoteCommand' for `ssh`.
function ssh_remote_command() {
	typeset -r session_name="$USER"

	typeset -r tmux_config_file="$XDG_CONFIG_HOME/tmux/tmux.conf"
	typeset -r tmux_config="$(tmux_conf_to_cmd_line "$tmux_config_file")"

	# NOTE: If something does not work, generate tmux logs with -v or -vv.
	typeset -r tmux_remote_command="tmux new-session -A -s '$session_name' $tmux_config \; set-option -g prefix C-b"

	# Try and use something that should be common like "xterm".
	typeset -r term="xterm-256color"
	echo "TERM=$term $tmux_remote_command"
}

# Open a `ssh` connection and create (or connect to) a tmux instance.
function sst() {
	# NOTE:
	#  -t: Force pseudo-terminal allocation
	#  -o: Option
	ssh -t -o "RemoteCommand $(ssh_remote_command)" "$@"
}

sst "$@"
