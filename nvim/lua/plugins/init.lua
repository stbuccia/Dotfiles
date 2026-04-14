return {
    --
    -- language packs
    { "sheerun/vim-polyglot" },

    -- UI
    {  "nordtheme/vim",
        lazy = false,          -- carica all’avvio
        priority = 1000,       -- garantisce il caricamento prima di altri colori
    },
    { "vim-airline/vim-airline" },

    -- fuzzy finder
    { "junegunn/fzf",   run = "./install --all", dir = "~/.fzf" },

    -- file explorer
    { "scrooloose/nerdtree" },

    -- git gutter
    { "airblade/vim-gitgutter" },

    -- LSP / completion
    { "prabirshrestha/vim-lsp" },
    { "neoclide/coc.nvim", branch = "release" },

    -- Copilot
    { "github/copilot.vim" },
    { "CopilotC-Nvim/CopilotChat.nvim" },

    -- utilities
    { "mileszs/ack.vim" },
    { "stevearc/aerial.nvim" },

    -- nvim‑only
    { "nvim-lualine/lualine.nvim",   cond = vim.fn.has "nvim" == 1 },
    { "liuchengxu/vista.vim",        cond = vim.fn.has "nvim" == 1 },
    { "kyazdani42/nvim-web-devicons",cond = vim.fn.has "nvim" == 1 },
    { "akinsho/toggleterm.nvim",     cond = vim.fn.has "nvim" == 1 },

    -- ... aggiungi qui gli altri plugin commentati se li riattivi
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'master',
        build = ':TSUpdate',
        config = function() 
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "php", "javascript", "html", "css" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end
    },
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `snacks` provider.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
            }

            -- Required for `opts.events.reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
            vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "t" }, "<C-l>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

            vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
            vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

            vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
            vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

            -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
            vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
            vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
        end,
    },
    {
        'numToStr/Comment.nvim',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end,
    },
}
