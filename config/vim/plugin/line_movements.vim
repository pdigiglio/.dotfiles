"" In terminal emulators, Alt-j is send as Esc+j. This function
"" uses a timeout to determine whether Alt-j or Esc+j is pressed. 
"let c='a'
"while c <= 'z'
"  exec "set <A-".c.">=\e".c
"  exec "imap \e".c." <A-".c.">"
"
"  " Increment the character counter by one
"  let c = nr2char(char2nr(c) + 1)
"endw
"
"set ttimeout ttimeoutlen=10

" Normal mode.
nnoremap <A-j> :move .+1<CR>==
nnoremap <A-k> :move .-2<CR>==

" Insert mode.
inoremap <A-j> <Esc>:move .+1<CR>==gi
inoremap <A-k> <Esc>:move .-2<CR>==gi

" Visual mode
vnoremap <A-j> :move '>+1gv=gv
vnoremap <A-k> :move '<-2gv=gv
