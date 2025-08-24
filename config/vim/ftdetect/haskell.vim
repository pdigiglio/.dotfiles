" Use haddock to format Haskell source files
"
" ormolu will output an error message if the parsing fails.
"autocmd BufNewFile,BufRead *.{,l}hs set formatprg=ormolu\ --no-cabal
