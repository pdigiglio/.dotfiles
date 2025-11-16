#!/bin/bash


typeset -r base_branch="origin/master"

function get_diff_files()
{
    git diff --name-status "$base_branch"...
}

function get_prompt_question()
{
    typeset -r file_status="$1"
    typeset -r file0="$2"
    typeset -r file1="${3:=${file0}}"

    case "$status" in
        R*)
            echo "Show diff from '$file0' to '$file1'"
            ;;

        "A")
            echo "Show new file '$file0'"
            ;;

        *)
            echo "Diff file '$file0'"
            ;;
    esac
}


function main()
{
    typeset -ri file_count="$(get_diff_files | wc -l)"
    typeset -i file_idx=1

    typeset status=""
    typeset file0=""
    typeset file1=""
    while read status file0 file1 
    do
        file1="${file1:=${file0}}"
        typeset question="$(get_prompt_question "$status" "$file0" "$file1")"

        typeset choice
        read -e -p " > ($file_idx / $file_count) $question? [y/n] " choice < /dev/tty
        if [[ "$choice" == [Yy] ]]
        then
            if [ "$status" == "A" ]
            then
                nvim "$file1"
            else
                nvim -d "$file1" <(git show "$base_branch":"$file0")
            fi

        fi

        file_idx=$((file_idx+1))
    done < <(get_diff_files)
}

main

