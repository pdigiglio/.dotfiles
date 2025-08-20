#!/bin/sh

# NOTE:
#
#  * If a file named InstalledBuild.txt exists, the generation of files for
#  VSCode gives an error.
#
#  * Some of the code below is inspired by this post:
#  https://gist.github.com/chillpert/1a76ae8e9cfafb36d3bf9e343d32fedc

typeset -r build_cfg="DebugGame"
typeset -r vs_code_folder=".vscode"
typeset -r additional_flags_file="$vs_code_folder/additional_lsp_flags.rsp"
typeset -r engine_root_path="$(ue4 root 2> /dev/null)"

typeset -r installed_build_txt_path="$engine_root_path/Engine/Build/InstalledBuild.txt"
typeset -r installed_build_txt_disabled_path="$engine_root_path/Engine/Build/InstalledBuild.txt.$$"

# Look for *.gch files and prefix them with "-include-pch" so that the output
# of this command can be used as compilation flags.
function get_gch_compile_flags()
{
    # NOTE: use "$find_root" instead of "." to get the absolute path instead of
    # a relative path in the output.
    typeset -r find_root="$(pwd)"
    find "$find_root" \
        -iname "*.gch" \
        -wholename "*/$build_cfg/*" \
        -type f \
        -exec echo "-include-pch \"{}\"" \;
}

# Print additional compile flags for clangd to stdout.
function get_additional_compile_flags()
{
    cat <<EOF
-Wall
-Wconversion
-Wextra
-Wpedantic
-std=c++20
EOF
}

function mv_file_if_exists()
{
    typeset -r from="$1"
    typeset -r to="$2"
    [[ -f "$from" ]] && mv --verbose "$from" "$to"
}

function stash_installed_build_txt()
{
    mv_file_if_exists "$installed_build_txt_path" "$installed_build_txt_disabled_path"
}

function restore_installed_build_txt()
{
    mv_file_if_exists "$installed_build_txt_disabled_path" "$installed_build_txt_path" 
}

function patch_compile_commands_json()
{
    typeset -r compile_cmds_json="$1"

    get_additional_compile_flags > "$additional_flags_file"

    typeset -r from_clang_pattern='".*clang++.*",'
    typeset -r       to_clang_cmd="\"clang++\", \"@$(realpath "$additional_flags_file")\","

    typeset -r sed_str="s:${from_clang_pattern}:${to_clang_cmd}:g"
    # echo "Sed string: '$sed_str'"
    
    # NOTE: --follow-symlinks is required. See:
    # https://unix.stackexchange.com/questions/192012/how-do-i-prevent-sed-i-from-destroying-symlinks
    sed \
        --in-place \
        --follow-symlinks \
        "$sed_str" "$compile_cmds_json"
}

function generate_lsp_compile_commands()
{
    typeset -r log_file="/dev/null"

    # Prevent <Ctrl-C> from leaving the engine folder in an inconsistent state.
    trap 'restore_installed_build_txt' SIGINT
    stash_installed_build_txt 
    ue4 gen -VSCode -WaitMutex -DisableUnity -NoPCH -NoLink &> "$log_file"
    restore_installed_build_txt 

    # At this point, ue4 should have created the .vscode folder.
    typeset -r compile_cmds_json=compile_commands.json

    # If the compilation DB existed and was not symlink, back it up.
    [ -f "$compile_cmds_json" ] && [ ! -L "$compile_cmds_json" ] &&
        mv -v "$compile_cmds_json"{,.bak}

    ln --symbolic --force "$vs_code_folder"/compileCommands_Default.json "$compile_cmds_json"

    patch_compile_commands_json "$compile_cmds_json"
}

# Generate a tag DB for Engine and project source files with ctags.
function generate_tags {
    echo "Generating ctags"
    ctags -R --c++-kinds=+p --fields=+iaS --extras=+q --languages=C++ "$engine_root_path/Engine/Source"
    ctags -R Source
}


# Print the usage on the stdout
function usage {
    cat <<EOF
Generate (and patch) a compilation DB for this project to be consumed by
clangd.

Usage: $0 [opts]
Options:
 -b  Build project before generating compilation DB
 -t  Generate ctags for the UE files.
 -h  Show this help
EOF
}

typeset -i gen_tags=0
while getopts "bht" opt
do
    case $opt in
        b)
            ue4 build $build_cfg > /dev/null
            echo "--"
            echo ""
            ;;

        t)
            generate_tags=1
            ;;

        h)
            usage
            exit 0
            ;;
    esac
done

generate_lsp_compile_commands
(( generate_tags != 0 )) && generate_tags

