-- Abilita il riconoscimento del tipo di file e i plugin
vim.cmd('filetype plugin indent on')

-- Opzioni di indentazione
vim.opt.smartindent   = true
vim.opt.autoindent    = true
vim.opt.smarttab      = true
vim.opt.shiftwidth    = 4
vim.opt.tabstop       = 4
vim.opt.expandtab     = true
vim.opt.cindent       = false  -- Disabilita cindent per evitare conflitti
--
-- -- Numeri di riga
vim.wo.number = true
--
-- -- Ricerca
-- vim.o.hlsearch      = true
-- vim.o.smartcase     = true
-- vim.o.ignorecase    = true
-- vim.o.incsearch     = true
--
-- -- Wildmenu e completamento
-- vim.o.wildmenu          = true
-- vim.o.wildignorecase    = true
-- vim.o.path = vim.o.path .. ',**'   -- ricerca ricorsiva
--
-- -- Autoreload
-- vim.o.autoread = true
--
-- -- Fold
-- vim.o.foldmethod = 'syntax'
--
-- -- Linebreak
-- vim.o.linebreak = true
--
-- -- Buffer nascosto
-- vim.o.hidden = true
--
-- -- Evidenzia colonna 81
-- vim.o.colorcolumn = '+1'
--
-- -- Shell
-- vim.o.shell = '/bin/bash'
--
-- -- Split a destra
-- vim.o.splitright = true
--
-- -- Mouse
-- vim.o.mouse = 'a'
--
-- -- Nascondi la modalità di inserimento
-- vim.o.showmode = false
--
-- -- Runtimepath per ctrlp (se usi Vim, per Neovim usa `vim.opt.rtp:prepend`)
-- vim.o.runtimepath = vim.o.runtimepath .. ',~/.vim/bundle/ctrlp.vim'
--
-- -- Encoding
-- vim.o.encoding = 'utf-8'
--
-- -- Aggiornamento file
-- vim.o.updatetime = 2000
--
-- -- Spellcheck
-- vim.o.spelllang = 'it,en'
--
-- -- Clipboard
-- vim.o.clipboard = 'unnamedplus'
--
-- -- Shape del cursore (solo Vim, non supportato nativamente da Neovim)
-- vim.cmd([[
-- let &t_SI = "\<Esc>[6 q"
-- let &t_SR = "\<Esc>[4 q"
-- let &t_EI = "\<Esc>[2 q"
-- ]])
--
-- -- Abilita la sintassi
-- vim.cmd('syntax on')
