" Detect Ogre3D material files and run the correct indentation file 
autocmd BufNewFile,BufRead *.material,*.program,*.particle setfiletype ogrematerial|runtime! ~/.vim/indent/ogrematerial.vim

"autocmd BufNewFile,BufRead *.material,*.program,*.particle runtime! ~/.vim/indent/ogrematerial.vim
