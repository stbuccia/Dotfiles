call plug#begin()

Plug 'sheerun/vim-polyglot' " A solid language pack for Vim. 
"Plug 'donRaphaco/neotex', { 'for': 'tex' } " latex live preview
Plug 'vim-airline/vim-airline' " lean & mean status/tabline for vim that's light as air 
Plug 'neomake/neomake'
Plug 'junegunn/fzf', {'dir' : '~/.fzf', 'do': './install --all'} " fzf che si aggiorna in automatico

" Theme

" Plug 'mhartington/oceanic-next'
Plug 'arcticicestudio/nord-vim'

" TagBar
Plug 'majutsushi/tagbar'

"set completeopt=noinsert,menuone,noselect

"" Generic Programming Support
"Plug 'honza/vim-snippets'
"Plug 'Townk/vim-autoclose'
"Plug 'tomtom/tcomment_vim'
"Plug 'tobyS/vmustache'
"Plug 'janko-m/vim-test'
"Plug 'maksimr/vim-jsbeautify'
"
Plug 'scrooloose/nerdtree' "Tree file explorer
"
""" Markdown / Writting
"Plug 'reedes/vim-pencil'
"Plug 'tpope/vim-markdown'
"Plug 'jtratner/vim-flavored-markdown'
"Plug 'dpelle/vim-LanguageTool'
"
"" Git Support
Plug 'airblade/vim-gitgutter' "Showed edited lines
"
"" PHP and others
"" Plug 'itchyny/lightline.vim'
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-abolish'
"Plug 'phpactor/phpactor'
"Plug 'phpactor/ncm2-phpactor'
"Plug 'amiorin/vim-project'
"Plug 'mhinz/vim-startify'
"Plug 'StanAngeloff/php.vim'
"Plug 'stephpy/vim-php-cs-fixer'
"Plug 'phpactor/phpactor'
"Plug 'adoy/vim-php-refactoring-toolbox'
"Plug 'stephpy/vim-php-cs-fixer'
"Plug 'SirVer/ultisnips'
"
"Plug 'majutsushi/tagbar'
"Plug 'joonty/vdebug'
"Plug 'tobyS/vmustache'
"Plug 'tobyS/pdv'
"Plug 'ryanoasis/vim-devicons'
"Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
"Plug 'bfredl/nvim-miniyank'
Plug 'scrooloose/nerdcommenter' " Shortcut per commentare
Plug 'prabirshrestha/vim-lsp'   " Language Server Protocol
"Plug 'dense-analysis/ale'       " ALE 
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'mileszs/ack.vim'
Plug 'stevearc/aerial.nvim'
" NeoVim only plugins
if has('nvim')
    "Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} "Preview markdown nel browser
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'liuchengxu/vista.vim' "Tagbar and fzf function search
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    "Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' } "Copilot alternative
    "Plug 'ggandor/lightspeed.nvim'
    " Plug 'shaunsingh/nord.nvim'
    " Plug 'catppuccin/nvim'
     Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
    "lua require("toggleterm").setup()
endif


call plug#end()

lua require"toggleterm".setup()

lua << EOF
require("CopilotChat").setup {
  -- See Configuration section for options
}
EOF

