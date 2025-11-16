# Source env.sh to make sure PATH is properly set.
. "$ZDOTDIR/env.sh"

# Ask qutebrowser to close the current tab, by writing the commands in
# `$QUTE_FIFO`.
function close_tab() {
    if ![ -p "$QUTE_FIFO" ]
    then
        echo "\$QUTE_FIFO (i.e. '$QUTE_FIFO') is not a named pipe (FIFO)." > /dev/stderr
        return 1
    fi

    cat >> $QUTE_FIFO <<EOF
    set --temp tabs.last_close close
    tab-close
    set tabs.last_close ignore
EOF
}
