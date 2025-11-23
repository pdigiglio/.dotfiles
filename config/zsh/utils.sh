# Check if an utility exists; i.e. if it can be called from the cmd line. The
# exit code is success, if the utility exists.
#
# @param $1 The utility name
function utility_exists() {
    typeset -r utility="$1"
    which "$1" > /dev/null
}

# This function should be called with a list of command names.  It will go
# though the list and return (on stdout) the first command that's installed.
#
# @param $@ The list of command to check.
#
# @return The name of the first installed utility (on stdout) or a non-zero
# error code.
#
# @remark For some reason the following will discard the error code of the
# shell-substituted command:
#
# ```sh
# local a=$(f)
# ```
# (Probably `local a` resets $?).  Use this, instead:
#
# ```sh
# local a
# a=$(f)
# ```
function find_if_utility_exists()
{
    for utility in "${@}"
    do
        if utility_exists "$utility"
        then
            echo "$utility"
            return $?
        fi
    done

    # Nothing found.
    return 1
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

# # Browse the installed packages with `fzf`
# # See: https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Browsing_packages
# function browse_installed_packages() {
#     typeset -r preview_cmd='pacman --query --info --list {}'
#     pacman --query --quiet |
#         fzf \
#         --multi \
#         --preview "$preview_cmd" \
#         --layout=reverse
#
#         # Let user decide what to do with selection.
#         # --bind "enter:execute( $preview_cmd | less )"
# }
#
# # Browse all the packages (even uninstalled) with `fzf`
# # See: https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Browsing_packages
# function browse_all_packages() {
#     typeset -r preview_cmd="yay --sync --info {}"
#     yay --sync --list --quiet |
#         fzf \
#         --multi \
#         --preview "$preview_cmd" \
#         --layout=reverse
# }

# Given a list of packages on stdin, use fzf to filter and show package info.
#
# NOTE:
#
#   To browse installed packages: pacman -Qq  | pacman_fzf
#
#   To browse all packages:       pacman -Slq | pacman_fzf
#          (including AUR)"       yay    -Slq | pacman_fzf
#
# See also:
# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Browsing_packages
function pacman_fzf() {
    typeset -r pacman=$(utility_exists "yay" && echo "yay" || echo "pacman")

    # The grep regex is:
    #  - At beginning of line
    #  - Not a space
    #  - Zero or more non-colons
    #  - A colon
    #  OR
    #  - The EOL (i.e. every line)
    # typeset -r preview_installed_pkg="$pacman --query --info {} | grep --color=always '^\S[^:]*:\|$' "
    typeset -r preview_installed_pkg="$pacman --query --info {} | grep --color=always '^\<Install\>[^:]*\|$' "
    typeset -r preview_uninstalled_pkg="$pacman --sync --info {} "
    typeset -r preview_cmd="$pacman -Qq {} &> /dev/null && ($preview_installed_pkg) || ($preview_uninstalled_pkg)"

    typeset -r green='ms=00;32'
    GREP_COLORS="$green" fzf \
        --multi \
        --preview "$preview_cmd" \
        --layout=reverse
}
