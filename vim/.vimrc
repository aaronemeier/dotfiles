" Vim config

" Load vim-plug - Plugin manager
call plug#begin('~/.vim/plugged')

" Load surround - Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'
Plug 'altercation/vim-colors-solarized'

" Load auto-pairs - Insert or delete brackets, parents, quotes in pair
Plug 'jiangmiao/auto-pairs'

" fzf on homebrew
if has('mac')
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
endif

" Initialize plugin system
call plug#end()

" Install plugins
:PlugInstall

" Strip trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" Unify indentation on save
autocmd BufWritePre * retab

" Set location for backup files
set backup
set backupdir=$HOME/.vim/backup/

" Set location for swap files (// means file will always be unique)
set directory=$HOME/.vim/swap//

" Write swap after 100 chars have been written
set updatecount=100

" Write no swap if only 5s have been passed since last write
set updatetime=5000

" Set location for undo files
set undofile
set undodir=$HOME/.vim/undo/

" Not necessary to state explicitly, just to make it very clear that we want vim
set nocompatible

" Enable solarized theme
syntax enable
set background=dark
colorscheme solarized

" Set spell check language
set spelllang=en_us

" Set how many spaces should be used for <Tab> key
set softtabstop=4

" Set how many spaces should be used for >> key
set shiftwidth=4

" Set how many spaces should be used for >> key after >>
set shiftround

" Set how many spaces shold be used for \t
set tabstop=4

" Use spaces instead of tabs
set expandtab

" Start search at top if end has been reached
set wrapscan

" Always report changed lines (e.g. "1 line yanked")
set report=0

" Only highlight the first 200 columns
set synmaxcol=200

" Show current mode in cli
set showmode

" Show the (partial) command as it is being typed
set showcmd

" Show matches between brackets
set showmatch

" Set time when to show the matching parent when showmatch is triggered
set matchtime=1

" Enable menu for command completion
set wildmenu
set wildmode=longest:full,full

" Highlight all matches from previous search pattern
set hlsearch

" Enable live searching
set incsearch

" Ignore case in search patterns
set ignorecase

" Always show statusline
set laststatus=2

" Show as much as possible of the last line in a document
set display=lastline

" Switch between buffers without having to save first
set hidden

" Disable vim welcome message
set shortmess=I

" Allow backspace in insert mode
set backspace=indent,eol,start

" Faster redrawing
set ttyfast

" Only redraw when necessary
set lazyredraw

" Enable relative line numbers
set relativenumber

" Do not reset cursor to start of line when moving around
set nostartofline

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Open new windows below the current window
set splitbelow

" Open new windows right of the current window
set splitright

" Soft wrapping of lines
set wrap linebreak

" Indent according to previous line
set autoindent

" Display a line below cursor position
set cursorline

" Display line numbers
set number

" Enable filetype detection, plugin and indent
filetype plugin indent on

" Enable basic mouse support
set mouse=a

" Enable Omni completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Remap tabbing for more convenience
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Enable clipboard on mac os
if has('mac')
  set clipboard=unnamed
endif

" Show non-printable characters in utf
set list
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif