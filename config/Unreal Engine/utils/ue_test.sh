#!/bin/bash

# For info about the UE commands below, see:
# https://stackoverflow.com/a/35339200

# Source the alias file to import `UnrealEditor-Linux-DebugGame`.
. "$XDG_CONFIG_HOME/Unreal Engine/aliases.sh"
. "$XDG_CONFIG_HOME/Unreal Engine/utils/utils.sh"

# @brief Filter the names of the tests from the output of `list_test`.
# @param 1 The input stream.
function filter_test_names()
{
    typeset -r in_file="$(in_file_or_stdin "$1")"
    
    # --silent: don't print lines that don't match the pattern
    sed --silent \
        "s/^.*\<LogAutomationCommandLine\>.*'\(.*\)'$/\1/p"  \
        "$in_file"
}

# @brief List the names of the test for a given *.uproject.
# @param 1 The full path of the UE project.
function list_tests()
{
    typeset -r project_full_path="$1"
    UnrealEditor-Linux-DebugGame \
        -project="$project_full_path" \
        -ExecCmds="Automation List"\
        -TestExit="Automation Test Queue Empty" \
        -Unattended \
        -NoPause \
        -NoSplash \
        -NullRhi \
        -NoSound 
}

# @brief Run a test.
# @param 1 The project full path.
# @param 2 The test name.
# @param 3 The "Rhi" mode (set it to 'rhi-on' to instanciate the GUI)
function run_test()
{
    typeset -r proj_full_path="$1"
    typeset -r test_name="$2"
    typeset -r rhi_mode="$3"

    if [ "$rhi_mode" == rhi-on ]
    then
        UnrealEditor-Linux-DebugGame \
            -Project="$proj_full_path" \
            -ExecCmds="automation RunTests ${test_name}; SoftQuit" \
            -Unattended \
            -NoPause \
            -NoSplash \
            -NoSound
    else
        # NOTE: Remove "-NullRhi" to instanciate the GUI.
        UnrealEditor-Linux-DebugGame \
            -Project="$proj_full_path" \
            -ExecCmds="automation RunTests ${test_name}; SoftQuit" \
            -Unattended \
            -NoPause \
            -NoSplash \
            -NullRhi \
            -NoSound
    fi
}

# @brief Print the usage of this command.
function usage()
{
    cat <<EOF
USAGE: $0 [-p <project>] [...]

OPTIONS:
  -p <project>  The Unreal Engine project.
                If omitted, the script looks for a *.uproject in the CWD.
 
  -l            List tests and exit (default action).

  -g            Instanciate the GUI. If not given, the editor will run
                in '-NullRhi' mode.
 
  -r <test>     Run the given test.
 
  -h            Show this help and exit.
EOF
}

# @brief The main function. Parse and validate the command line args; select
# the appropriate script behavior.
# @param ... The command line arguments.
function main()
{
    typeset project=""
    typeset test_name=""
    typeset -i list=1
    typeset -i usage=0
    typeset -i error=0
    typeset -i rhi_on=0

    local OPTIND
    while getopts "p:lr:gh" opt
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

            g)
                rhi_on=1
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

    project="$(project_or_default "$project")"
    if [[ -z "$project" ]] || ! stat "$project" > /dev/null 
    then
        echo "Missing project file (-p)." > /dev/stderr
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

    typeset -r project_full_path="$(realpath "$project")"

    if (( list ))
    then
        list_tests "$project_full_path" 2>/dev/null | filter_test_names
    elif [[ -n "$test_name" ]]
    then
        typeset rhi_mode="rhi-off"
        if (( rhi_on == 1 ))
        then
            rhi_mode="rhi-on"
        fi

        run_test "$project_full_path" "$test_name" "$rhi_mode"
    fi
}

main "$@"
