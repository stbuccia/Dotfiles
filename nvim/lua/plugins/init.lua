return {
    --
    -- language packs
    { "sheerun/vim-polyglot" },

    -- UI
    {
        "nordtheme/vim",
        lazy = false,
        priority = 1000,
    },
    {
        "rcarriga/nvim-notify",
        lazy = false,
        priority = 900,
        config = function()
            local notify = require("notify")
            notify.setup({
                background_colour = "#2E3440",
                stages            = "fade",
                timeout           = 2000,
                render            = "compact",
            })
            vim.notify = notify
        end,
    },
    { "vim-airline/vim-airline" },

    -- project management
    {
        "ahmedkhalf/project.nvim",
        lazy = false,
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern", "lsp" },
                patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "pyproject.toml" },
                show_hidden = false,
                silent_chdir = true,
            })
        end,
    },

    -- dashboard
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("alpha_config")
        end,
    },

    -- fuzzy finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        lazy = false,
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({
                files = {
                    fd_opts = "--type f --hidden --exclude .git",
                    cmd     = "fdfind --type f --hidden --exclude .git",
                },
                winopts = {
                    height  = 0.85,
                    width   = 0.85,
                    preview = {
                        layout = "horizontal",
                        ratio  = 60,
                    },
                },
                fzf_opts = {
                    ["--layout"] = "reverse",
                },
            })

            -- keymaps
            local map = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            map("<C-p>", fzf.files, "FZF: trova file")
            map("<leader>fg", fzf.live_grep, "FZF: live grep (ripgrep)")
            map("<leader>fd", function()
                fzf.files({
                    prompt  = "Directory> ",
                    fd_opts = "--type d --hidden --exclude .git",
                    actions = {
                        ["default"] = function(selected)
                            if selected and selected[1] then
                                local dir = selected[1]:match("^(.+)$")
                                fzf.live_grep({ cwd = dir })
                            end
                        end,
                    },
                })
            end, "FZF: live grep in directory")
            map("<leader>fb", fzf.buffers, "FZF: buffer aperti")
            map("<leader>fh", fzf.help_tags, "FZF: help tags")
            map("<leader>fr", fzf.oldfiles, "FZF: file recenti")
            map("<leader>fs", fzf.lsp_document_symbols, "FZF: simboli documento")
            map("<leader>fw", fzf.grep_cword, "FZF: cerca parola sotto cursore")
        end,
    },

    -- file explorer (nvim-tree al posto di NERDTree)
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("nvim_tree_config")
        end,
    },

    -- git gutter
    { "airblade/vim-gitgutter" },

    -- LSP nativo
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- mason: installa i server automaticamente
            { "williamboman/mason.nvim",           config = true },
            { "williamboman/mason-lspconfig.nvim", config = true },
            -- LuaSnip (sorgente snippet per nvim-cmp)
            { "L3MON4D3/LuaSnip",                  version = "v2.*", build = "make install_jsregexp" },
            { "saadparwaiz1/cmp_luasnip" },
            { "rafamadriz/friendly-snippets" },
            -- sorgenti nvim-cmp
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/nvim-cmp" },
        },
        config = function()
            require("lsp_config")
        end,
    },

    -- Copilot (versione Lua)
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot_lua_config")
        end,
    },
    -- sorgente copilot per nvim-cmp
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    -- CopilotChat aggiornato
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            debug = false,
        },
    },

    -- DAP (debugger)
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap_config")
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },

    -- lazygit
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    -- lazydocker
    {
        "mgierada/lazydocker.nvim",
        lazy = true,
        dependencies = { "akinsho/toggleterm.nvim" },
        keys = {
            { "<leader>ld", "<cmd>Lazydocker<cr>", desc = "LazyDocker" },
        },
        config = function()
            require("lazydocker").setup({})
        end,
    },

    -- utilities
    { "mileszs/ack.vim" },
    { "stevearc/aerial.nvim" },

    -- nvim-only
    { "nvim-lualine/lualine.nvim", cond = vim.fn.has("nvim") == 1 },
    { "liuchengxu/vista.vim",      cond = vim.fn.has("nvim") == 1 },
    {
        "kyazdani42/nvim-web-devicons",
        cond   = vim.fn.has("nvim") == 1,
        lazy   = false,
        config = function()
            require("nvim-web-devicons").setup({
                -- abilita un'icona di fallback per i tipi non riconosciuti
                default = true,
                -- override per estensioni che a volte mancano
                -- override_by_extension = {
                --     ["md"]   = { icon = "", color = "#519aba", name = "Markdown" },
                --     ["mdx"]  = { icon = "", color = "#519aba", name = "Mdx" },
                --     ["lua"]  = { icon = "", color = "#51a0cf", name = "Lua" },
                --     ["php"]  = { icon = "", color = "#a074c4", name = "Php" },
                --     ["js"]   = { icon = "", color = "#cbcb41", name = "Js" },
                --     ["ts"]   = { icon = "", color = "#519aba", name = "Ts" },
                --     ["json"] = { icon = "", color = "#cbcb41", name = "Json" },
                --     ["css"]  = { icon = "", color = "#42a5f5", name = "Css" },
                --     ["html"] = { icon = "", color = "#e44d26", name = "Html" },
                --     ["env"]  = { icon = "", color = "#faf743", name = "Env" },
                --     ["yml"]  = { icon = "", color = "#6d8086", name = "Yml" },
                --     ["yaml"] = { icon = "", color = "#6d8086", name = "Yaml" },
                --     ["toml"] = { icon = "", color = "#9c4221", name = "Toml" },
                --     ["sh"]   = { icon = "", color = "#4d5a5e", name = "Sh" },
                --     ["vim"]  = { icon = "", color = "#019833", name = "Vim" },
                --     ["lock"] = { icon = "", color = "#bbbbbb", name = "Lock" },
                --     ["git"]  = { icon = "", color = "#f14c28", name = "Git" },
                -- },
            })
        end,
    },
    { "akinsho/toggleterm.nvim", cond = vim.fn.has("nvim") == 1 },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query",
                    "markdown", "markdown_inline",
                    "php", "javascript", "typescript",
                    "html", "css",
                },
                auto_install     = true,
                highlight        = { enable = true },
                indent           = { enable = true },
            })
        end,
    },

    -- opencode.nvim
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
        },
        config = function()
            vim.g.opencode_opts = {}
            vim.o.autoread = true

            vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
                { desc = "Ask opencode…" })
            vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
                { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "t" }, "<C-l>", function() require("opencode").toggle() end,
                { desc = "Toggle opencode" })

            vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
                { desc = "Add range to opencode", expr = true })
            vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
                { desc = "Add line to opencode", expr = true })

            vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
                { desc = "Scroll opencode up" })
            vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
                { desc = "Scroll opencode down" })

            vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
            vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
        end,
    },

    -- commenti
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },

    -- TODO
    {
        "atiladefreitas/dooing",
        config = function()
            require("dooing").setup({
                -- your custom config here (optional)
                -- Core settings
                save_path = vim.fn.stdpath("data") .. "/dooing_todos.json",

                -- Window settings
                window = {
                    width = 55, -- Width of the floating window
                    height = 20, -- Height of the floating window
                    border = 'rounded', -- Border style
                    padding = {
                        top = 1,
                        bottom = 1,
                        left = 2,
                        right = 2,
                    },
                },

                -- To-do formatting
                formatting = {
                    pending = {
                        icon = "○",
                        format = { "icon", "notes_icon", "text", "due_date", "ect" },
                    },
                    in_progress = {
                        icon = "◐",
                        format = { "icon", "text", "due_date", "ect" },
                    },
                    done = {
                        icon = "✓",
                        format = { "icon", "notes_icon", "text", "due_date", "ect" },
                    },
                },

                quick_keys = true, -- Quick keys window

                notes = {
                    icon = "📓",
                },

                scratchpad = {
                    syntax_highlight = "markdown",
                },

                -- Keymaps
                keymaps = {
                    toggle_window = "<leader>td",
                    new_todo = "i",
                    toggle_todo = "x",
                    delete_todo = "d",
                    delete_completed = "D",
                    close_window = "q",
                    undo_delete = "u",
                    add_due_date = "H",
                    remove_due_date = "r",
                    toggle_help = "?",
                    toggle_tags = "t",
                    toggle_priority = "<Space>",
                    clear_filter = "c",
                    edit_todo = "e",
                    edit_tag = "e",
                    delete_tag = "d",
                    search_todos = "/",
                    add_time_estimation = "T",
                    remove_time_estimation = "R",
                    import_todos = "I",
                    export_todos = "E",
                    remove_duplicates = "<leader>D",
                    open_todo_scratchpad = "<leader>p",
                },

                calendar = {
                    language = "en",
                    icon = "",
                    keymaps = {
                        previous_day = "h",
                        next_day = "l",
                        previous_week = "k",
                        next_week = "j",
                        previous_month = "H",
                        next_month = "L",
                        select_day = "<CR>",
                        close_calendar = "q",
                    },
                },

                -- Priority settings
                priorities = {
                    {
                        name = "important",
                        weight = 4,
                    },
                    {
                        name = "urgent",
                        weight = 2,
                    },
                },
                priority_groups = {
                    high = {
                        members = { "important", "urgent" },
                        color = nil,
                        hl_group = "DiagnosticError",
                    },
                    medium = {
                        members = { "important" },
                        color = nil,
                        hl_group = "DiagnosticWarn",
                    },
                    low = {
                        members = { "urgent" },
                        color = nil,
                        hl_group = "DiagnosticInfo",
                    },
                },
                hour_score_value = 1 / 8,

            })
        end,
    }
}
