-- ============================================================
-- nvim-dap + nvim-dap-ui configuration
-- Infrastruttura base: UI, keymaps, segni.
-- Aggiungi gli adapter specifici per linguaggio qui sotto.
-- ============================================================

local dap    = require("dap")
local dapui  = require("dapui")

-- ============================================================
-- 1. dap-ui setup
-- ============================================================
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    layouts = {
        {
            elements = {
                { id = "scopes",      size = 0.35 },
                { id = "breakpoints", size = 0.20 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.20 },
            },
            size    = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl",    size = 0.5 },
                { id = "console", size = 0.5 },
            },
            size    = 10,
            position = "bottom",
        },
    },
    floating = {
        max_height  = nil,
        max_width   = nil,
        border      = "rounded",
        mappings    = { close = { "q", "<Esc>" } },
    },
    render = {
        max_type_length = nil,
        max_value_lines = 100,
    },
})

-- Apri/chiudi dap-ui automaticamente quando inizia/termina una sessione
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- ============================================================
-- 2. Segni visivi per i breakpoint
-- ============================================================
vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint",            { text = "◇", texthl = "DapLogPoint",            linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped",             { text = "→", texthl = "DapStopped",             linehl = "DapStopped", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })

-- ============================================================
-- 3. Keymaps
-- ============================================================
local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- controllo sessione
map("<F5>",       dap.continue,          "DAP: continue / start")
map("<F10>",      dap.step_over,         "DAP: step over")
map("<F11>",      dap.step_into,         "DAP: step into")
map("<F12>",      dap.step_out,          "DAP: step out")
map("<leader>db", dap.toggle_breakpoint, "DAP: toggle breakpoint")
map("<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "DAP: conditional breakpoint")
map("<leader>dl", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "DAP: log point")
map("<leader>dr", dap.repl.open,         "DAP: open REPL")
map("<leader>ds", dap.run_last,          "DAP: run last config")
map("<leader>dt", dapui.toggle,          "DAP: toggle UI")
map("<leader>de", dapui.eval,            "DAP: eval expression")

-- ============================================================
-- 4. Adapter per linguaggi
--    Aggiungi qui la configurazione specifica.
--    Esempio PHP (xdebug):
-- ============================================================
--
-- dap.adapters.php = {
--     type = "executable",
--     command = "node",
--     args    = { "/path/to/vscode-php-debug/out/phpDebug.js" },
-- }
-- dap.configurations.php = {
--     {
--         type    = "php",
--         request = "launch",
--         name    = "Listen for Xdebug",
--         port    = 9003,
--     },
-- }
--
-- Esempio Node.js:
-- dap.adapters["pwa-node"] = {
--     type = "server",
--     host = "localhost",
--     port = "${port}",
--     executable = {
--         command   = "node",
--         args      = { "/path/to/js-debug/src/dapDebugServer.js", "${port}" },
--     },
-- }
-- dap.configurations.javascript = {
--     {
--         type    = "pwa-node",
--         request = "launch",
--         name    = "Launch file",
--         program = "${file}",
--         cwd     = "${workspaceFolder}",
--     },
-- }
