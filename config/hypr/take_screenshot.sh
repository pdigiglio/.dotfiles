#!/bin/sh

#  @requires@ grim
#  @requires@ slurp
#  @requires@ dunst

# A script to simplify taking screenshots in Hyprland.
#
# This script requires:
#
#  * grim
#  * slurp
#  * dunst (for notifications)
#
# Author: Paolo Di Giglio
#
# TODO: 
#  * split help and screenshot-taken notification.
#  * Open preview when screenshot-taken notif clicked (e.g. with feh -.)

# Get $XDG_STATE_HOME, if the variable is set, or the default value.
function get_xdg_state_home()
{
    [[ -v XDG_STATE_HOME ]] &&
        echo "$XDG_STATE_HOME" ||
        echo "$HOME/.local/state"
}

# Get the file where the notification ID (NID) gets stored.
#
# Params:
#  (none)
function get_nid_file()
{
    typeset -r state_home="$(get_xdg_state_home)"
    typeset -r state_dir="$state_home/take_screenshot"

    # Make sure directory exist
    mkdir -p "$state_dir"

    echo "$state_dir/take_screenshot.nid"
}

typeset -r nid_file="$(get_nid_file)"

# Extract a window property.
#
# Params:
#  $1 The info about the active window.
#  $2 The property to extract (it must be either "size" or "at").
#
# The active-window info is assumed to be obtained from:
#
# ```
# $ hyprctl activewindow
# Window 57c262884660 -> hyprctl activewindow >> curr_slurp.sh:
# 	mapped: 1
# 	hidden: 0
# 	at: 2,28
# 	size: 1362,738
# 	workspace: 1 (1)
# 	floating: 0
# 	pseudo: 1
# 	monitor: 0
# 	class: kitty
# 	title: hyprctl activewindow >> curr_slurp.sh
# 	initialClass: kitty
# 	initialTitle: kitty
# 	pid: 26796
# 	xwayland: 0
# 	pinned: 0
# 	fullscreen: 1
# 	fullscreenClient: 1
# 	grouped: 0
# 	tags: 
# 	swallowing: 0
# 	focusHistoryID: 0
# 	inhibitingIdle: 0
# ```
function get_active_window_property()
{
    typeset -r active_window_info="$1"
    typeset -r param="$2"

    echo "$active_window_info" |
        grep --extended-regexp "${param}:[[:space:]]+[-+0-9]+,[-+0-9]+" |
        cut --fields=2 --delimiter=':' |
        tr --delete "[:blank:]"
}

# Get the geometry of the currently active window.
#
# Params:
#  (none)
function get_active_window_geometry()
{
    typeset -r active_window_info="$(hyprctl activewindow)"
    typeset -r   at=$(get_active_window_property "$active_window_info" "at")
    typeset -r size=$(get_active_window_property "$active_window_info" "size" | tr ',' 'x')
    echo "$at $size"
}

# Display a notification and report its ID.
#
# Params:
#  $1 (title) The notification title
#  $2 (body)  The notification body
#
# Returns:
#  Notification ID on stdout.
function notify()
{
    typeset -r screen_notif_tag="wayland-screenshot"
    typeset -r screen_notif_hint="string:x-canonical-private-synchronous:$screen_notif_tag"
    typeset -r title="$1"
    typeset -r body="$2"
    dunstify "$title" "$body" -h "$screen_notif_hint" --printid
}

# Take a screenshot.
#
# Params:
#  $1 (geometry) The area to capture. Format "<x>,<y> <width>x<height>"
function take_screenshot()
{
    typeset -r geometry="$1"

    typeset -r basename=$(date "+screen_%Y-%m-%d_%H:%M:%S")
    typeset -r extension="png"

    typeset -r target_dir="$HOME/Pictures/screens"
    typeset -r target_filename="${basename}.${extension}"

    # Take screenshot and store it in the clipboard.
    grim -g "$geometry" -t "$extension" - | wl-copy

    # Hide the help notification. Not needed, at this point.
    hide_help_notification 

    # Open the screenshot with `feh` and present some user actions.
    typeset -r target_file="$target_dir/$target_filename"
    typeset -Ar actions=(
        # --
        [copy_desc]="Copy to clipboard"
        [copy]="cat %F|wl-copy"
        # --
        [extract_desc]="Extract text (tesseract)"
        [extract]="tesseract %F stdout|wl-copy"
        # --
        [save_desc]="Save screenshot"
        [save]="mkdir -p '$target_dir' && cat %F > '$target_file'"
        # --
        [open_desc]="Open screenshot folder (yazi)"
        [open]="kitty yazi '$target_file'"
    )

    wl-paste --type image/${extension} |
        feh - \
        --scale-down \
        --action1="[${actions[copy_desc]}]${actions[copy]}" \
        --action2="[${actions[extract_desc]}]${actions[extract]}" \
        --action3="[${actions[save_desc]}]${actions[save]}" \
        --action4="[${actions[open_desc]}]${actions[open]}" \
        --draw-actions
}

# Display the help notification for the screenshot mode.
#
# Params:
#  (none)
function show_help_notification()
{
    typeset -r title="Hyprland Screenshot Mode"
    typeset -r body=$(
cat <<EOF
  <b>Mod-S</b> Select area
  <b>Mod-W</b> Capture active window
  <b>Mod-X</b> Hide this notification
  <b>Esc  </b> Abort
EOF
)

    # Display the help notification and store its ID so that I can close the
    # notification later (if needed).
    notify "$title" "$body" > "$nid_file"
}

# Hide the help notification for the screenshot mode.
#
# Params:
#  (none)
function hide_help_notification()
{
    if [[ -f "$nid_file" ]]
    then
        typeset -r nid=$(cat "$nid_file")
        dunstify --close=$nid
    fi
}

function screenshot_selected_area()
{
    # NOTE: if I declare and assign `geometry` on the same line, the error code
    # of `slurp` gets overridden. I don't know why.
    local geometry
    geometry="$(slurp 2> /dev/null)"

    typeset -ir err_code=$?
    if [ $err_code -ne 0 ] 
    then
        typeset -r title="Screenshot acquisition aborted." 
        notify "$title" "" > /dev/null
        return $err_code
    fi

    take_screenshot "$geometry"
}

# Show the help for this script.
function usage()
{
    cat <<EOF
Take a screenshot using "grim".

USAGE: $0 <option>

OPTIONS (mutually exclusive and mandatory):
 -w  Screenshot the currently-active window.
 -s  Select the area to screenshot (using "slurp").
 -n  Show help notification for screenshot mode.
 -x  Hide help notification for screenshot mode.
 -h  Show this help.
EOF
}

while getopts 'swnxh' OPTION
do
    case "$OPTION" in
        w)
            take_screenshot "$(get_active_window_geometry)"
            exit $?
            ;;

        s)
            screenshot_selected_area
            exit $?
            ;;

        n)
            show_help_notification
            exit $?
            ;;

        x)
            hide_help_notification
            exit $?
            ;;

        h)
            usage
            exit $?
            ;;

        ?)
            # fall through and show usage.
            break
            ;;

    esac
done

usage
exit 1
