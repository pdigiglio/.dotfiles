#!/bin/bash

function fzf_title() {
    typeset -r title_regexp='^\s\+\<title\>: '
    hyprctl clients |
        grep "$title_regexp" |
        sed "s/$title_regexp//" |
        fzf --preview "sh preview.sh {}"
}

function get_address() {
    typeset -r title="$1"

    hyprctl clients |
        grep "^Window\>.*$title:"  |
        cut -f 2 -d ' '
}

function main()
{
    typeset -r title="$(fzf_title)"
    typeset -r address="$(get_address "$title")"
    hyprctl dispatch focuswindow address:0x${address}
}

main







