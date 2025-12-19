" Use UNIX `column` to format Doxygen parameter descrtiption.
"
" The idea is to turn this:
"
" /// @param x Help for x
" /// @param do_this Whether to to this
"
" Into this:
"
" /// @param x       Help for x
" /// @param do_this Whether to to this
"
" -- Limitations --
"  * The must be a space between the comment char and '@param'
"  * Lines that don't start with '@param' will be messed up.
"
vnoremap <buffer> <Leader>= :'<,'>! column --separator ' ' --output-separator ' ' --table --table-columns-limit 4<CR>
