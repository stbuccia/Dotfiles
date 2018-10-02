function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'roxma/nvim-completion-manager'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'donRaphaco/neotex', { 'for': 'tex' }
Plug 'mhartington/oceanic-next'
Plug 'vim-airline/vim-airline'
Plug 'neomake/neomake'

" deoplete config
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_smart_case = 1
" set sources
let g:deoplete#sources = {}
let g:deoplete#sources.cpp = ['LanguageClient']
let g:deoplete#sources.python = ['LanguageClient']
let g:deoplete#sources.python3 = ['LanguageClient']
let g:deoplete#sources.rust = ['LanguageClient']
let g:deoplete#sources.c = ['LanguageClient']
let g:deoplete#sources.vim = ['vim']

" deoplete-racer config
let g:deoplete#sources#rust#racer_binary='/Users/aenayet/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path= '/Users/aenayet/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src'
let g:deoplete#enable_at_startup = 1

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
call plug#end()

" NeoMake automatic
" When writing a buffer (no delay).
call neomake#configure#automake('w')
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing (no delay).
call neomake#configure#automake('rw', 1000)
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500)

if (has("termguicolors"))
 set termguicolors
endif
colorscheme OceanicNext
syntax enable
filetype plugin on
filetype plugin indent on
set autoindent
set smartindent
set smarttab
set relativenumber
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap ( ()<Esc>i
inoremap " ""<Esc>i
inoremap ` ``<Esc>i
inoremap <C-Backspace> <Esc>dbi
set number
set shiftwidth=4
set path^=**              " Recursive file search starting from current dir
set wildmenu              " Tab autocompletion in menu
set wildignorecase        " Ignore case when autocomplete
set autoread              " Autoreload file if modified from external command
set hlsearch              " Highlight all search results
set smartcase             " Smart-case search
set ignorecase            " Case-insensitive
set incsearch             " Incremental search
set autoindent            " Auto-indent
set smartindent           " Smart indent
set tabstop=4             " show existing tab with 4 spaces width
set shiftwidth=4          " when indenting with '>', use 4 spaces width
set expandtab             " On pressing tab, insert 4 spaces
set foldmethod=syntax     " Fold according to syntax
set linebreak             " Break long lines at spaces, not in the middle of a word
set hidden                " Allow to switch buffer without saving it
set colorcolumn=+1        " Highlight column where the 81/th char lives
set shell=/bin/bash\ -i   " Which shell to use
set spelllang=it,en       " Spell dictionaries
set splitright            " vsplit on the right
set mouse=a               " Enable mouse in terminal vim
execute pathogen#infect()
call pathogen#helptags()
