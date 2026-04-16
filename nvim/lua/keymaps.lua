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

-- Cd con fzf tramite shortcut <leader>cd
vim.keymap.set('n', '<leader>cd', function()
    local home = vim.fn.expand("~")
    require("fzf-lua").fzf_exec("fd --type d --hidden --exclude .git . " .. home .. " | sed 's|" .. home .. "|~|'", {
        prompt  = "cd> ",
        actions = {
            ["default"] = function(selected)
                if selected and selected[1] then
                    local dir = selected[1]:match("^%s*(.-)%s*$"):gsub("^~", home)
                    vim.cmd("cd " .. vim.fn.fnameescape(dir))
                    vim.schedule(function()
                        local cwd = vim.fn.getcwd():gsub("^" .. home, "~")
                        vim.notify("  " .. cwd, vim.log.levels.INFO, { title = "cd" })
                    end)
                end
            end,
        },
    })
end, { noremap = true, silent = true, desc = "cd con fzf" })
