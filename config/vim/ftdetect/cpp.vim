" This drops me off the editor
"function! cpp#Format()
"    let l:fromLine = v:lnum
"    let l:toLine = v:lnum + v:count
"    let l:bufferInEdit=expand('%:p')
"    let l:cmdLine="!clang-format \"".l:bufferInEdit."\" -i --lines=".l:fromLine.":".l:toLine
"    echomsg l:cmdLine
"    execute l:cmdLine
"
"    " Prevent vim from using its internal formatting
"    return 0
"endfunction

" Use clang-format to format C/C++ files
"autocmd BufNewFile,BufRead *.{c,h}{,pp} setlocal formatexpr=cpp#Format()
autocmd BufNewFile,BufRead *.{c,h}{,pp} set formatprg=clang-format\ --assume-filename=file.cpp

