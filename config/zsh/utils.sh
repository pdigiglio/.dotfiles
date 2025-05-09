# Check if an utility exists; i.e. if it can be called from the cmd line. The
# exit code is success, if the utility exists.
#
# @param $1 The utility name
function utility_exists() {
    typeset -r utility="$1"
    which "$1" > /dev/null
}

# Check which package(s) provides a given file. Similar to `pacman -Qo <file>`
# but you don't need to specify a file path (a posix BRE is fine).
#
# @param $1 The posix BRE to look for
function which_package_provides() {
    typeset -r file_regex="$1"
    if [ -z "$file_regex" ]
    then
        cat > /dev/stderr  <<EOF
A search term is required.
USAGE: $0 'regex'
EOF

        return 1
    fi

    pacman --query --list |
        grep "$file_regex" |
        cut --fields 1 --delimiter ' ' |
        sort --unique
}

# Browse the installed packages with `fzf`
# See: https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Browsing_packages
function browse_installed_packages() {
    typeset -r preview_cmd='pacman --query --info --list {}'
    pacman --query --quiet |
        fzf \
        --preview "$preview_cmd" \
        --layout=reverse \
        --bind "enter:execute( $preview_cmd | less )"
}

# Browse all the packages (even uninstalled) with `fzf`
# See: https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Browsing_packages
function browse_all_packages() {
    typeset -r preview_cmd="yay --sync --info {}"
    yay --sync --list --quiet |
        fzf \
        --preview "$preview_cmd" \
        --layout=reverse
}
