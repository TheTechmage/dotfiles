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

"Line 80 "Helpful Correction Reminder"
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/


" TODO implement this when I get a chance
"
" In your vimrc you can read an environment variable to allow
" different command depending on which OS or PC you're on and
" thus have same vimrc.
"
"if $USER == 'davidr'
"	echo "on home pc"
"	set .. etc
"else
"	echo "on work pc"
"	set .. etc
"endif
