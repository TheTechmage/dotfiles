"set number
syntax on
filetype indent on
set modeline

set rnu
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars=eol:¶,tab:>-,trail:·,extends:>,precedes:<,nbsp:%
set list

set ts=2 sw=2 ai

function SmoothScroll(up)
	if a:up
		let scrollaction="Y"
	else
		let scrollaction="E"
	endif
	exec "normal " . scrollaction
	redraw
	let counter=1
	while counter<&scroll
		let counter+=1
		sleep 10m
		redraw
		exec "normal " . scrollaction
	endwhile
endfunction

nnoremap <C-U> :call SmoothScroll(1)<Enter>
nnoremap <C-D> :call SmoothScroll(0)<Enter>
inoremap <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <C-D> <Esc>:call SmoothScroll(0)<Enter>i

filetype plugin indent on
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
