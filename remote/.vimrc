set background=dark
colorscheme gruvbox
let g:solarized_termtrans=1

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

set nocompatible
set clipboard=unnamed
set wildmenu
set esckeys
set backspace=indent,eol,start
set ttyfast
set gdefault
set encoding=utf-8 nobomb
let mapleader=","
set binary
set noeol
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

set backupskip=/tmp/*,/private/tmp/*

set modeline
set modelines=4
set exrc
set secure
set number
syntax on
set cursorline
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set noerrorbells
set nostartofline
set ruler
set shortmess=atI
set showmode
set title
set showcmd

function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
noremap <leader>W :w !sudo tee % > /dev/null<CR>

if has("autocmd")
	filetype on
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif
