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
set listchars=eol:Â¶,tab:>-,trail:Â·,extends:>,precedes:<,nbsp:%

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
		let scrollaction=""
	else
		let scrollaction=""
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

"nnoremap <F5> m'A<C-R>="\t".strftime('%Y-%m-%d %H:%M')<CR><Esc>``
nnoremap <F5> m'A<C-R>="\t".strftime('%a %b %e %H:%M:%S %Z %Y')<CR><Esc>``

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
"set rtp+=~/.vim/nonbundle
set rtp+=~/.vim/bundle/vundle
set rtp+=~/.vim/autoload
call vundle#rc()

" Bundles!
Bundle 'gmarik/vundle'
"Bundle 'msanders/snipmate.vim'
"Bundle 'Lokaltog/vim-powerline', {'rtp': 'powerline/bindings/vim/'}
" Arch disabled python
Bundle 'szw/vim-tags'
Bundle 'hynek/vim-python-pep8-indent'

"C++ autocomplete
Bundle 'Valloric/YouCompleteMe'

"Powerline Support
"Note:
"http://makandracards.com/jan0sch/18283-enable-powerline-fonts-with-rxvt-unicode-and-vim-airline
Bundle 'bling/vim-airline'

" Vim Golang Support
Bundle 'fatih/vim-go'

" Vim better js support
Bundle 'pangloss/vim-javascript'

" Vim Snip-Mate {{{
	Bundle "MarcWeber/vim-addon-mw-utils"
	Bundle "tomtom/tlib_vim"
	Bundle "garbas/vim-snipmate"

	" Optional:
	Bundle "honza/vim-snippets"
" }}}

call plug#begin()
" Alignment
Plug 'junegunn/vim-easy-align'
" The below doesn't work
" Bundle 'junegunn/vim-easy-align'
call plug#end()

filetype indent on
filetype plugin indent on
" "}}}
" Vundle Bundle Config {{{

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 3
let g:airline#extensions#tabline#left_sep='î‚°'
let g:airline#extensions#tabline#left_alt_sep=''
let g:airline_theme="simple"
set laststatus=2

" }}}

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
"raise PSAPIException(msg = 'Debugging: %s' % e,
"            code = 500,
"            info = 'Debugging: %s' % e)
let @b="oexcept Exception, e:raise PSAPIException(msg = 'Debugging: %s' % e,code = 500,info = 'Debugging: %s' % e)€ku€ku"
set nolist
match

" ##    ## ######## ##    ##  ######  
" ##   ##  ##        ##  ##  ##    ## 
" ##  ##   ##         ####   ##       
" #####    ######      ##     ######  
" ##  ##   ##          ##          ## 
" ##   ##  ##          ##    ##    ## 
" ##    ## ########    ##     ######  

" Splits
" https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright
vnoremap <f2> :<c-u>exe join(getline("'<","'>"),'<bar>')<cr>

" ##    ##  #######  ######## ########  ######
" ###   ## ##     ##    ##    ##       ##    ##
" ####  ## ##     ##    ##    ##       ##
" ## ## ## ##     ##    ##    ######    ######
" ##  #### ##     ##    ##    ##             ##
" ##   ### ##     ##    ##    ##       ##    ##
" ##    ##  #######     ##    ########  ######
"
" Match command and syntax
" http://vimdoc.sourceforge.net/htmldoc/pattern.html#:match
