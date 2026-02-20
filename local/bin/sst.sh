#!/bin/env bash

function tmux_conf_to_cmd_line()
{
    typeset -r tmux_conf="$1"

    sed 's/^\s*#.*//g' "$tmux_conf" |
        grep --invert-match "^\s*$" |
        sed 's/^/ \\; /g' |
        sed 's/%/%%/g' |
        sed 's/"/\\"/g' |
        paste --serial --delimiters=" "
}

function ssh_remote_command()
{
    typeset -r session_name="$USER"
    typeset -r term="tmux-256color"
    typeset -r tmux_config_file="$XDG_CONFIG_HOME/tmux/tmux.conf"
    typeset -r tmux_config="$(tmux_conf_to_cmd_line "$tmux_config_file")"
    typeset -r tmux_remote_command="tmux new-session -A -s '$session_name' $tmux_config \; set-option -g prefix C-b"
    echo "TERM=$term; $tmux_remote_command"
}

function main()
{
    # Note:
    #  -t: Force pseudo-terminal allocation
    #  -o: Option
    ssh -t -o "RemoteCommand $(ssh_remote_command)" "$@"
}

main "$@"
