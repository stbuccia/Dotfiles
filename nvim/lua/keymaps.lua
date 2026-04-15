local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Normal mode: <C-n> per aprire/chiudere nvim-tree (stesso shortcut di NERDTree)
map('n', '<C-n>', ':NvimTreeToggle<CR>', opts)

-- Normal mode: <leader>nf per trovare il file corrente nell'albero
map('n', '<leader>nf', ':NvimTreeFindFile<CR>', opts)

-- Insert mode: <C-Backspace> per uscire, cancellare una parola indietro e rientrare in insert
map('i', '<C-Backspace>', '<Esc>dbi', opts)

-- Diagnostica flottante con il cursore fermo
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Open diagnostic float" })

-- Lista diagnostica (quickfix)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostic quickfix list" })

-- Apri documentazione shortcut
vim.keymap.set('n', '<leader>?', function()
    vim.cmd('e ' .. vim.fn.stdpath('config') .. '/KEYMAPS.md')
end, { noremap = true, silent = true, desc = "Apri KEYMAPS.md" })

-- Apri cartella configurazione Neovim
vim.keymap.set('n', '<leader>C', function()
    vim.cmd('e ~/Dotfiles/nvim/ | cd ~/Dotfiles/nvim/')
end, { noremap = true, silent = true, desc = "Apri configurazione Neovim" })
