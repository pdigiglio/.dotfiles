" Execute a Ex command `cmd` and display its output in a new buffer in the
" current window.
"
" See: https://vim.fandom.com/wiki/Capture_ex_command_output
function! BufRedir(cmd)
    " Open new buffer in current window.
    enew

    " This buffer is not associated to any file.
    setlocal buftype=nofile

    " When  this buffer is no longer displayed in a window, wipe it from the
    " buffer list.
    setlocal bufhidden=wipe

    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodified


    pu=execute(a:cmd)
endfunction

command! -nargs=+ -complete=command BufRedir call BufRedir(<q-args>)
