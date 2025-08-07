#!/bin/bash

. "$XDG_CONFIG_HOME/Unreal Engine/aliases.sh"

# For info about the UE commands below, see:
# https://stackoverflow.com/a/35339200

function filter_test_names()
{
    typeset -r in_file="$1"
    
    # --silent: don't print lines that don't match the pattern
    sed --silent \
        "s/^.*\<LogAutomationCommandLine\>.*'\(.*\)'$/\1/p"  \
        "$in_file"
}

function list_tests()
{
    typeset -r project_full_path="$1"
    UnrealEditor-Linux-DebugGame \
        -project="$project_full_path" \
        -ExecCmds="Automation List"\
        -TestExit="Automation Test Queue Empty" \
        -unattended \
        -nopause \
        -nullrhi \
        -nosound 
}

function run_test()
{
    typeset -r proj_full_path="$1"
    typeset -r test_name="$2"

    UnrealEditor-Linux-DebugGame \
        -project="$proj_full_path" \
        -ExecCmds="automation RunTests ${test_name}; SoftQuit" \
        -unattended \
        -nopause \
        -nosplash \
        -nullrhi \
        -nosound
}

function usage()
{
    cat <<EOF
Usage: $0 -p <project> [...]

Options:

 -p <project>  The Unreal Engine project
 -l            List tests and exit (default action)
 -r <test>     Run the given test
 -h            Show this help and exit.
EOF
}


function main()
{
    typeset project=""
    typeset test_name=""
    typeset -i list=1
    typeset -i usage=0
    typeset -i error=0

    local OPTIND
    while getopts "p:lr:h" opt
    do
        case $opt in
            p)
                project="${OPTARG}"
                ;;

            l)
                list=1
                ;;

            h)
                usage=1
                ;;

            r)
                test_name="${OPTARG}"
                list=0
                ;;

            *)
                error=1
                ;;
        esac
    done

    if [[ -z "$project" ]]
    then
        echo "Project file (-p) is mandatory." > /dev/stderr
        error=1
    fi

    if (( error ))
    then
        usage > /dev/stderr
        exit 1
    fi

    if (( usage ))
    then
        usage
        exit 0
    fi

    stat "$project" > /dev/null || exit 1

    typeset -r project_full_path="$(realpath "$project")"

    if (( list ))
    then
        list_tests "$project_full_path" | filter_test_names /dev/stdin
    fi

    if [[ -n "$test_name" ]]
    then
        run_test "$project_full_path" "$test_name"
    fi
}

main "$@"
