" I want to keep `gq` to the default.
"setlocal formatprg=pandoc\ -t\ commonmark_x

" `=` should format tables.
"autocmd FileType md setlocal equalprg=pandoc\ -f\ markdown\ -t\ commonmark_x
" If you don't have pandoc, use `column`
setlocal equalprg=column\ --separator=\"\|\"\ --output-separator=\"\|\"\ --table
