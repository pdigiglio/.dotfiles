#!/bin/bash

. "$XDG_CONFIG_HOME/Unreal Engine/utils/utils.sh"


# Get the sed script that will be used to patch the input template launch.json
function get_sed_script()
{
    typeset -r project_full_path="$(realpath "$1")"
    typeset -r project_basename="$(basename --suffix '.uproject' "${project_full_path}")"
    typeset -r editor_full_path="$(get_unreal_engine_binary_path)/UnrealEditor-Linux-DebugGame"
    typeset -r lldb_init_full_path="$HOME/.lldbinit"
    typeset -r test_case_name="<test-name>"


    cat <<EOF
# Delete whole-line comments
/^\s*\/\/.*$/d

s|##PROJECT_BASENAME##|${project_basename}|g
s|##PROJECT_FULL_PATH##|${project_full_path}|g
s|##EDITOR_FULL_PATH##|${editor_full_path}|g
s|##LLDB_INIT_FULL_PATH##|${lldb_init_full_path}|g
s|##TEST_CASE_NAME##|${test_case_name}|g
EOF
}

typeset -r project="$(get_default_project)"
typeset -r template="$XDG_CONFIG_HOME/Unreal Engine/templates/launch.json.template"
sed \
    --file <(get_sed_script "$project") \
    "$template"
