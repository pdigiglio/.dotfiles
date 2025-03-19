#!/bin/zsh

# A small script to `watch` my task list. I need to override some "rc" values
# to get a satisfying report.
#
# Run with:
#
# watch --color --no-title sh tw.sh

function tw {
    typeset -r lines=$(tput lines)
    typeset -r cols=$(tput cols)
    task \
        rc.verbose:0 \
        rc.limit:page \
        rc.defaultwidth:$cols \
        rc.defaultheight:$lines \
        long

        # rc._forcecolor:on \
        # rc.detection:off \
}

tw
