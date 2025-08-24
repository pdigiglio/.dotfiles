setlocal colorcolumn=80

" These parameters for tab (should) match the ones of the 'ormolu' Haskell
" formatter.
setlocal tabstop=2
setlocal shiftwidth=2

"echo "haskell"

" Enable haskell-language-server
"lua require('lspconfig')['hls'].setup{ autostart = true }
