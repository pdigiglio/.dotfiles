# Aliases for Unreal Engine
. "$ZDOTDIR/utils.sh"

# The code below depends on the existence of ue4.
utility_exists ue4 || return 0

. "$XDG_CONFIG_HOME/Unreal Engine/utils/utils.sh"

alias UnrealEditor-Linux-DebugGame="\"$(get_unreal_engine_binary_path)\"/UnrealEditor-Linux-DebugGame "

# TODO: Either create an alias (like so) or a symlink in ~/.local/bin. With the
# symlink, the usage message will not contain the real path of the script. Try:
#
# ```sh
# ue_test -h
# ```
#
# and check.
alias ue_test="sh \"$XDG_CONFIG_HOME/Unreal Engine\"/utils/ue_test.sh "
alias ue_gen_compile_commands="sh \"$XDG_CONFIG_HOME/Unreal Engine\"/utils/ue_gen_compile_commands.sh "
alias ue_gen_launch_json="sh \"$XDG_CONFIG_HOME/Unreal Engine\"/utils/ue_gen_launch_json.sh "

