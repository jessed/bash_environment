" The statusline definition has been moved to here to allow it to be sourced,
" (the the statusline colorscheme reset) without sourcing the full .vimrc, 
" which would also reset the default colorscheme and other options

my statusline
set statusline=
set statusline +=%4*%<%f%*              " Relative path to the file
set statusline +=%5*%m%*                " Modified flag
set statusline +=%2*\ %{&ff}            " File format (unix, dos, mac)
set statusline +=\ %3*%y%*              " File type (syntax)
set statusline +=%1*%=                  " Align to the right
set statusline +=%3*%l%*                " Current line number
set statusline +=%6*/%3*%L              " Total lines
set statusline +=\ %3*(%1*%p%%%3*)        " Current line number as %
set statusline +=%7*%4v\ %*             " Virtual column number
set statusline +=%1*%{strftime(\"%H:%M\")}  
"set statusline +=%5*0x%04B\ %*          " character under cursor


" some color variables for use with the statusline 
hi User1  ctermfg=DarkRed
hi User2  ctermfg=Magenta
hi User3  ctermfg=LightBlue
hi User4  ctermfg=DarkYellow
hi User5  ctermfg=Red
hi User6  ctermfg=White
hi User7  ctermfg=Cyan
