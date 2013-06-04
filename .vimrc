"set number
syntax on
set number ts=2 sw=2
set modeline
set nocompatible
set mouse=a
set mousehide
if has ('x') && has ('gui') " On Linux use + register for copy-paste
	set clipboard=unnamedplus
elseif has ('gui')          " On mac and Windows, use * register for copy-paste
	set clipboard=unnamed
endif
set showmode
set cursorline

filetype off

set rtp+=~/.dotfiles/vundle
call vundle#rc()

" Vundle manages Bundles for vim =)
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-surround'
Bundle 'majutsushi/tagbar'
Bundle 'spf13/vim-autoclose'
Bundle 'altercation/vim-colors-solarized'

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'honza/vim-snippets'
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'flazz/vim-colorschemes'

" Vim UI {
	if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
"		let g:solarized_termcolors=256
		color solarized                 " Load a colorscheme
	endif
	let g:solarized_termtrans=1
	let g:solarized_contrast="high"
	let g:solarized_visibility="high"
	set tabpagemax=15               " Only show 15 tabs
	set showmode                    " Display the current mode
	highlight clear SignColumn      " SignColumn should match background for things like vim-gitgutter
	set ruler                   " Show the ruler
	if has('cmdline_info')
		set ruler                   " Show the ruler
		set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
		set showcmd                 " Show partial commands in status line and
																" Selected characters/lines in visual mode
	endif
	set backspace=indent,eol,start  " Backspace for dummies
	set linespace=0                 " No extra spaces between rows
	set nu                          " Line numbers on
	set showmatch                   " Show matching brackets/parenthesis
	set incsearch                   " Find as you type search
	set hlsearch                    " Highlight search terms
	set winminheight=0              " Windows can be 0 line high
	set ignorecase                  " Case insensitive search
	set smartcase                   " Case sensitive when uc present
	set wildmenu                    " Show list instead of just completing
	set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
	set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
	set scrolljump=5                " Lines to scroll when cursor leaves screen
	set scrolloff=3                 " Minimum lines to keep above and below cursor
	set foldenable                  " Auto fold code
	set list
	set listchars=tab:.\ ,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
" }
let g:neocomplcache_enable_at_startup = 1

function! NumberToggle()
	if(&relativenumber == 1)
		set number
	else
		set relativenumber
	endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
syntax enable
set background=dark
colorscheme solarized
set laststatus=2
set encoding=utf-8

set viminfo='20,\"50
set history=50
set ruler

" Jump to last cursor position in file. Yipee! =D
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\ 	exe "normal! g'\"" |
			\ end

filetype indent on
filetype plugin indent on
