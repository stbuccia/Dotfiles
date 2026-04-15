require("config.lazy")      -- Bootstrap & inizializza lazy.nvim
require("options")          -- Opzioni editor
require("keymaps")          -- Mappature tasti base
require("appearance")       -- Colorscheme
require("comment_config")   -- Comment.nvim + indent PHP
-- Nota: lsp_config, nvim_tree_config, copilot_lua_config e dap_config
--       sono caricati direttamente dai rispettivi plugin in plugins/init.lua
--       tramite il campo `config = function() ... end`.
