#!/bin/env bash

function get_diff_files()
{
    typeset -r base_branch="$1"
    git diff --name-status "$base_branch"...
}

function get_prompt_question()
{
    # typeset -r file_status="$1"
    typeset -r file0="$2"
    typeset -r file1="${3:=${file0}}"

    case "$status" in
        R*)
            echo "Show diff from '$file0' to '$file1'"
            ;;

        "A")
            echo "Show new file '$file0'"
            ;;

        "D")
            echo "Show deleted file '$file0'"
            ;;

        *)
            echo "Diff file '$file0'"
            ;;
    esac
}


function interactive_difftool()
{
    typeset -r base_branch="$1"
    typeset -ri file_count="$(get_diff_files "$base_branch" | wc -l)"
    typeset -i file_idx=1

    typeset status=""
    typeset file0=""
    typeset file1=""
    typeset question=""
    while read status file0 file1 
    do
        file1="${file1:=${file0}}"
        question="$(get_prompt_question "$status" "$file0" "$file1")"

        typeset choice
        read -e -p " > ($file_idx / $file_count) $question? [y/n] " choice < /dev/tty
        if [[ "$choice" == [Yy] ]]
        then
            if [ "$status" == "A" ]
            then
                nvim "$file1"
            elif [ "$status" == "D" ]
            then
                nvim <(git show "$base_branch":"$file0")
            else
                nvim -d "$file1" <(git show "$base_branch":"$file0")
            fi

        fi

        file_idx=$((file_idx+1))
    done < <(get_diff_files "$base_branch")
}

function main()
{
    typeset base_branch="origin/master"

    typeset OPTIND
    typeset OPTARG
    while getopts "b:" opt
    do
        case "$opt" in
            b)
                base_branch="$OPTARG"
                ;;
            *)
                echo "Unknown option" > /dev/stderr
                exit 1
                ;;
        esac
    done

    interactive_difftool "$base_branch"
}

main "$@"

