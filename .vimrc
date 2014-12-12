"set number
syntax on
set modeline
set mouse=nv

"File type specific settings
au BufNewFile,BufRead *.ejs set filetype=html

"Droplets don't have utf-8 by default >_>
scriptencoding utf-8
set encoding=utf-8

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars=eol:¶,tab:>-,trail:·,extends:>,precedes:<,nbsp:%

set ts=2 sw=2 ai

if hostname() == 'Toronto'
	set rnu
	set list
endif

" Use LaTeX configuration if on Ogre
if hostname() == 'Ogre'
	"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	"% Set the following lines in your ~/.vimrc or the systemwide /etc/vimrc:
	"% filetype plugin indent on
	"% set grepprg=grep\ -nH\ $*
	"% let g:tex_flavor = "latex"
	"% 
	"% Also, this installs to /usr/share/vim/vimfiles, which may not be in
	"% your runtime path (RTP). Be sure to add it too, e.g:
	"% set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
	"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	filetype plugin indent on
	set grepprg=grep\ -nH\ $*
	let g:tex_flavor = "latex"
	set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
endif

let b:domainhost = split(hostname(), '\.')
if len(b:domainhost) >= 1 && b:domainhost[0] == 'ipa'
	set list ts=4 sw=4 et
endif

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

"let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
let &titlestring = "vim(" . expand("%:t") . ")"
let &titleold="-vim"
if &term == "screen" || &term == "screen-256color"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "screen-256color"
  set title
endif

au BufRead,BufNewFile *.less setfiletype css

" Line 80 "Helpful Correction Reminder"
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Vundle Stuff "{{{
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Bundles!
Bundle 'gmarik/vundle'
Bundle 'msanders/snipmate.vim'
"Bundle 'Lokaltog/vim-powerline', {'rtp': 'powerline/bindings/vim/'}
" Arch disabled python
Bundle 'szw/vim-tags'
Bundle 'hynek/vim-python-pep8-indent'

filetype indent on
filetype plugin indent on
" "}}}

" Return to our last position in the file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

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
