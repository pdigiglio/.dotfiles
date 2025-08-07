# Aliases for Unreal Engine
. "$ZDOTDIR/utils.sh"

# The code below depends on the existence of ue4.
utility_exists ue4 || return 0

# Get the path of the UE executables on the fly.
function get_unreal_engine_path() {
    typeset -r unreal_engine_root="$(ue4 root 2> /dev/null)"
    echo "${unreal_engine_root}/Engine/Binaries/Linux"
}

typeset -r unreal_engine_path="$(get_unreal_engine_path)"
alias UnrealEditor-Linux-DebugGame="\"$unreal_engine_path\"/UnrealEditor-Linux-DebugGame "

# TODO: Either create an alias (like so) or a symlink in ~/.local/bin. With the
# symlink, the usage message will not contain the real path of the script. Try:
#
# ```sh
# ue_test -h
# ```
#
# and check.
alias ue_test="sh \"$HOME/.config/Unreal Engine\"/utils/ue_test.sh "

