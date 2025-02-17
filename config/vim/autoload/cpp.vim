"function CppFormat()
"    echomsg "fmt"
"endfunction
"
"echomsg "autoload.cpp"
"set formatexpr=CppFormat()
"
"
"" Use clang-format to format C/C++ files
"#autocmd BufNewFile,BufRead *.cpp setlocal formatexpr=CppFormat()
