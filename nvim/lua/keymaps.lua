local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Normal mode: <C‑n> per aprire/chiudere NERDTree
map('n', '<C-n>', ':NERDTreeToggle<CR>', opts)

-- Insert mode: <C‑Backspace> per uscire, cancellare una parola indietro e rientrare in insert
map('i', '<C-Backspace>', '<Esc>dbi', opts)

-- Normal mode: <F8> per aprire/chiudere Tagbar
map('n', '<F8>', ':TagbarToggle<CR>', opts)
