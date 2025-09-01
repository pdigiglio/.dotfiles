# General utility functions for Unreal Engine
#
# This file assumes ue4 is installed.

# Get the path of the UE executables.
function get_unreal_engine_binary_path() {
    typeset -r unreal_engine_root="$(ue4 root 2> /dev/null)"
    echo "${unreal_engine_root}/Engine/Binaries/Linux"
}

function in_file_or_stdin()
{
    typeset -r in_file="$1"

    if [[ -f "$in_file" ]]
    then
        echo "$in_file"
    elif [[ -z "$in_file" ]] || [[ "$in_file" == "-" ]]
    then
        echo "/dev/stdin"
    else
        echo "No such file '$in_file'" > /dev/stderr
        exit 1
    fi
}

# @brief Find UE projects (*.uproject) in a given folder
# @param 1 The folder to look into.
function find_uprojects_in_folder()
{
    typeset -r folder="$1"
    find "$folder" \
        -maxdepth 1 \
        -iname "*.uproject"
}

# @brief Find a default UE project in the current folder.
#
# There must be only one file *.uproject, otherwise the function will return an
# empty string.
function get_default_project()
{
    typeset -r folder="."
    typeset -ri default_project_count=$(find_uprojects_in_folder "$folder" | wc -l)
    (( default_project_count != 1 )) && echo "" || find_uprojects_in_folder  "$folder"
}

# @brief Return the input project string or a default one.
# @param 1 A (possibly empty) project string
function project_or_default()
{
    typeset -r project="$1"
    [[ -n "$project" ]] && echo "$project" || get_default_project
}

