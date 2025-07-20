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

