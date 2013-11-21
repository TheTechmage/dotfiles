"set number
syntax on
filetype indent on
set modeline

filetype plugin indent on
syntax on
"let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
let &titlestring = "vim(" . expand("%:t") . ")"
let &titleold="-vim"
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm"
  "set title
endif

au BufRead,BufNewFile *.less setfiletype css
