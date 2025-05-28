#!/bin/bash


typeset fields="^Window\>"
fields="$fields|\<workspace\>:"
fields="$fields|\<hidden\>:"
fields="$fields|\<floating\>:"
fields="$fields|\<pseudo\>:"
fields="$fields|\<monitor\>:"
fields="$fields|\<class\>:"
fields="$fields|\<pid\>:"
fields="$fields|\<xwayland\>:"
fields="$fields|\<fullscreen\>:"
fields="$fields|\<tags\>:"

# Note: this matches the number of fields I look for (minus 1).
typeset -i after_ctx=10
# typeset -r title="Wayland to X Recording bridge — Xwayland Video Bridge"
typeset -r title="$1"

hyprctl clients |
    grep --extended-regexp "$fields" | 
    grep --after-context=${after_ctx} "^Window\>.*$title:"  |
    sed 's/^Window[[:space:]]\+[a-f0-9]\+[[:space:]]\+->//'

    #grep --after-context=${after_ctx} "^Window\>.*\<$title\>:"  |

