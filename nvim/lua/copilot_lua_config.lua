-- ============================================================
-- copilot.lua configuration
-- Sostituisce github/copilot.vim con zbirenbaum/copilot.lua.
-- Il suggerimento è integrato direttamente in nvim-cmp
-- tramite copilot-cmp (sorgente "copilot" in lsp_config.lua).
-- ============================================================

require("copilot").setup({
    -- Disabilita il pannello (non utile se si usa cmp)
    panel = {
        enabled   = false,
        auto_refresh = false,
    },
    -- Disabilita i suggerimenti inline (ghost text) perché
    -- vengono mostrati da nvim-cmp. Impostare a true se si
    -- preferisce il ghost text nativo invece del menu cmp.
    suggestion = {
        enabled    = false,
        auto_trigger = false,
        keymap = {
            accept        = "<M-l>",
            accept_word   = false,
            accept_line   = false,
            next          = "<M-]>",
            prev          = "<M-[>",
            dismiss       = "<C-]>",
        },
    },
    -- Filetype: stessi di copilot.lua precedente
    filetypes = {
        markdown  = true,
        text      = true,
        gitcommit = true,
        gitrebase = true,
        help      = true,
        json      = true,
        yaml      = true,
        php       = true,
        python    = true,
        javascript = true,
        typescript = true,
        html      = true,
        css       = true,
        lua       = true,
        -- disabilita in file molto larghi (prestazioni)
        ["*"] = function()
            return vim.api.nvim_buf_get_name(0):len() < 1000000
        end,
    },
    copilot_node_command = "node",
    server_opts_overrides = {},
})
