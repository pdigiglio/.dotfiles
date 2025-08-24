" Associate *.sng with song filetypes
autocmd BufRead,BufNewFile *.sng setfiletype song
" Enable folding (and fold everything)
autocmd Syntax song setlocal foldmethod=syntax
" Open all the folds
autocmd Syntax song normal zR
