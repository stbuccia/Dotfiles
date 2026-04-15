-- ============================================================
-- nvim-tree.lua configuration
-- Sostituisce NERDTree (<C-n> rimane lo stesso shortcut)
-- ============================================================

-- Richiesto da nvim-tree: disabilita netrw
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 35,
        side  = "left",
    },
    renderer = {
        group_empty = true,
        icons = {
            show = {
                file        = true,
                folder      = true,
                folder_arrow = true,
                git         = true,
            },
        },
    },
    filters = {
        dotfiles = false,   -- mostra i dotfile (come NERDTree default)
    },
    git = {
        enable = true,
        ignore = false,
    },
    actions = {
        open_file = {
            quit_on_open = false,
            window_picker = {
                enable = true,
            },
        },
    },
    -- Sincronizza la root con la directory del file corrente
    update_focused_file = {
        enable      = true,
        update_root = false,
    },
})

-- Chiudi nvim automaticamente se nvim-tree è l'ultima finestra aperta
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
                table.insert(invalid_win, w)
            end
        end
        if #invalid_win == #wins - 1 then
            -- è rimasta solo nvim-tree: chiudi
            for _, w in ipairs(invalid_win) do
                vim.api.nvim_win_close(w, true)
            end
        end
    end,
})
