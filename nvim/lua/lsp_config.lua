-- ============================================================
-- LSP + nvim-cmp configuration
-- Usa vim.lsp.config / vim.lsp.enable (API nativa nvim 0.11+)
-- al posto di lspconfig.xxx.setup() (deprecato in nvim-lspconfig v3).
-- Language servers: intelephense (PHP), ts_ls (TS/JS),
--                   jsonls, html, cssls
-- ============================================================

local cmp          = require("cmp")
local luasnip      = require("luasnip")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Carica snippet di default (VSCode-like)
require("luasnip.loaders.from_vscode").lazy_load()

-- ============================================================
-- 1. Capabilities condivise — estende quelle di default con cmp
-- ============================================================
local capabilities = cmp_nvim_lsp.default_capabilities()

-- ============================================================
-- 2. Keymaps LSP — registrati via LspAttach autocmd
-- ============================================================
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(event)
        local bufnr = event.buf
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        -- navigazione codice
        map("n", "gd",  vim.lsp.buf.definition,     "Goto definition")
        map("n", "gy",  vim.lsp.buf.type_definition, "Goto type definition")
        map("n", "gi",  vim.lsp.buf.implementation,  "Goto implementation")
        map("n", "gr",  vim.lsp.buf.references,      "Goto references")

        -- documentazione
        map("n", "K",   vim.lsp.buf.hover,           "Hover documentation")

        -- diagnostica
        map("n", "[g",  vim.diagnostic.goto_prev,    "Previous diagnostic")
        map("n", "]g",  vim.diagnostic.goto_next,    "Next diagnostic")

        -- refactoring
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>ac", vim.lsp.buf.code_action, "Code action")
        map("n", "ga",         vim.lsp.buf.code_action, "Code action (cursor)")
        map({ "n", "x" }, "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, "Format")

        -- organizza import
        map("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },
                apply   = true,
            })
        end, "Organize imports")

        -- highlight simbolo al fermo del cursore (solo se il server lo supporta)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight") then
            local hl_group = vim.api.nvim_create_augroup("LspDocHighlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer   = bufnr,
                group    = hl_group,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                buffer   = bufnr,
                group    = hl_group,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- ============================================================
-- 3. Configurazione server con vim.lsp.config (nvim 0.11+)
-- ============================================================

-- PHP — intelephense (completamento, diagnostica, inferenza tipi)
vim.lsp.config("intelephense", {
    capabilities = capabilities,
    settings = {
        intelephense = {
            environment = { phpVersion = "8.1" },
            files       = { maxSize = 5000000 },
        },
    },
})

-- PHP — phpactor (code actions e refactoring)
-- Disabilitiamo diagnostica e hover per non entrare in conflitto con intelephense.
vim.lsp.config("phpactor", {
    capabilities = capabilities,
    handlers = {
        -- Ignora diagnostica da phpactor (la gestisce intelephense)
        ["textDocument/publishDiagnostics"] = function() end,
    },
    on_attach = function(client)
        -- Lascia solo code actions, disabilita il resto
        client.server_capabilities.hoverProvider              = false
        client.server_capabilities.completionProvider         = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.signatureHelpProvider      = false
    end,
})

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
    capabilities = capabilities,
})

-- JSON
vim.lsp.config("jsonls", {
    capabilities = capabilities,
})

-- HTML
vim.lsp.config("html", {
    capabilities = capabilities,
})

-- CSS / SCSS / Less
vim.lsp.config("cssls", {
    capabilities = capabilities,
})

-- Attiva tutti i server configurati sopra
vim.lsp.enable({ "intelephense", "ts_ls", "jsonls", "html", "cssls", "phpactor" })

-- ============================================================
-- 4. Diagnostica globale
-- ============================================================
vim.diagnostic.config({
    virtual_text     = true,
    signs            = true,
    update_in_insert = false,
    severity_sort    = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

vim.o.updatetime = 300
vim.o.signcolumn  = "yes"

-- ============================================================
-- 5. nvim-cmp setup
-- ============================================================
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {},
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"]     = cmp.mapping.select_next_item(),
        ["<C-k>"]     = cmp.mapping.select_prev_item(),
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "copilot",  priority = 100 },
        { name = "nvim_lsp", priority = 90  },
        { name = "luasnip",  priority = 80  },
        { name = "buffer",   priority = 50  },
        { name = "path",     priority = 40  },
    }),
})

local cmdline_mapping = vim.tbl_extend("force", cmp.mapping.preset.cmdline(), {
    ["<C-j>"] = { c = cmp.mapping.select_next_item() },
    ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
})

-- Completamento su /
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmdline_mapping,
    sources = { { name = "buffer" } },
})

-- Completamento su :
cmp.setup.cmdline(":", {
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
    }),
})

-- ============================================================
-- 6. Comandi utili
-- ============================================================
vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format current buffer via LSP" })

vim.api.nvim_create_user_command("OR", function()
    vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply   = true,
    })
end, { desc = "Organize imports via LSP" })

-- ============================================================
-- 7. Segni diagnostici nella sign column
-- ============================================================
local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
