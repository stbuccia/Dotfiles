-- ============================================================
-- alpha-nvim — dashboard custom
-- Layout: header ASCII "NEOVIM" + file recenti + menu + footer
-- ============================================================

local alpha   = require("alpha")
local themes  = require("alpha.themes.theta")
local devicons = require("nvim-web-devicons")

-- Restituisce icona + hl_group per un file dato il suo path
local function file_icon(filepath)
    local filename  = vim.fn.fnamemodify(filepath, ":t")
    local ext       = vim.fn.fnamemodify(filepath, ":e")
    local icon, hl  = devicons.get_icon(filename, ext, { default = true })
    return icon or "", hl or "AlphaButton"
end

-- ============================================================
-- 1. Header ASCII
-- ============================================================
local header = {
    type = "text",
    val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                     ",
    },
    opts = { position = "center", hl = "AlphaHeader" },
}

-- ============================================================
-- 2. File recenti (ultimi 5) con path abbreviato
-- ============================================================
local function shorten_path(path)
    local home    = vim.fn.expand("~")
    local max_len = 45
    path = path:gsub("^" .. home, "~")
    if #path <= max_len then return path end
    -- Abbrevia le directory intermedie alla prima lettera
    local parts    = vim.split(path, "/")
    local filename = table.remove(parts)
    for i = 2, #parts - 1 do
        if parts[i] ~= "" and parts[i] ~= "~" then
            parts[i] = parts[i]:sub(1, 1)
        end
    end
    local shortened = table.concat(parts, "/") .. "/" .. filename
    -- Se ancora troppo lungo, tronca con ellissi a sinistra
    if #shortened > max_len then
        shortened = "…" .. shortened:sub(-(max_len - 1))
    end
    return shortened
end

local function get_recent_files()
    local items   = {}
    local keys    = { "1", "2", "3", "4", "5" }
    for _, file in ipairs(vim.v.oldfiles) do
        if #items >= 5 then break end
        if vim.fn.filereadable(file) == 1 then
            local display       = shorten_path(file)
            local key           = keys[#items + 1]
            local icon, icon_hl = file_icon(file)
            -- alpha usa colonne in byte; l'icona è 3 byte (UTF-8 multibyte) + 2 spazi
            local icon_bytes    = #icon
            local sep           = "  "
            local sep_bytes     = #sep
            table.insert(items, {
                type = "button",
                val  = icon .. sep .. display,
                on_press = function()
                    vim.cmd("e " .. vim.fn.fnameescape(file))
                end,
                opts = {
                    position       = "center",
                    shortcut       = "[" .. key .. "]",
                    cursor         = 3,
                    width          = 52,
                    align_shortcut = "right",
                    hl             = {
                        { icon_hl,       0,                           icon_bytes },
                        { "AlphaButton", icon_bytes + sep_bytes,      icon_bytes + sep_bytes + #display },
                    },
                    hl_shortcut    = "AlphaShortcut",
                    keymap = {
                        "n", key,
                        ":e " .. vim.fn.fnameescape(file) .. "<CR>",
                        { noremap = true, silent = true, nowait = true },
                    },
                },
            })
        end
    end
    return items
end

local recent_files = {
    type = "group",
    val = function()
        local files = get_recent_files()
        if #files == 0 then
            return {
                { type = "text", val = "  Nessun file recente", opts = { position = "center", hl = "AlphaFooter" } },
            }
        end
        return vim.list_extend(
            { { type = "text", val = "  File recenti", opts = { position = "center", hl = "AlphaShortcut" } } },
            files
        )
    end,
    opts = { spacing = 0 },
}

-- ============================================================
-- 3. Progetti recenti (via project.nvim)
-- ============================================================
local function get_recent_projects()
    local ok, project_nvim = pcall(require, "project_nvim")
    if not ok then return {} end
    local recent_projects = project_nvim.get_recent_projects()
    if not recent_projects or #recent_projects == 0 then return {} end

    local items = {}
    local keys  = { "a", "b", "c", "d", "e" }
    local folder_icon  = ""
    local folder_bytes = #folder_icon   -- 3 byte UTF-8
    local sep          = "  "
    local sep_bytes    = #sep
    for i, proj in ipairs(recent_projects) do
        if i > 5 then break end
        local display = shorten_path(proj)
        local key     = keys[i]
        table.insert(items, {
            type = "button",
            val  = folder_icon .. sep .. display,
            on_press = function()
                vim.cmd("cd " .. vim.fn.fnameescape(proj))
                vim.cmd("NvimTreeOpen")
            end,
            opts = {
                position       = "center",
                shortcut       = "[" .. key .. "]",
                cursor         = 3,
                width          = 52,
                align_shortcut = "right",
                hl             = {
                    { "AlphaFolder", 0,                              folder_bytes },
                    { "AlphaButton", folder_bytes + sep_bytes,       folder_bytes + sep_bytes + #display },
                },
                hl_shortcut    = "AlphaShortcut",
                keymap = {
                    "n", key,
                    ":cd " .. vim.fn.fnameescape(proj) .. " | NvimTreeOpen<CR>",
                    { noremap = true, silent = true, nowait = true },
                },
            },
        })
    end
    return items
end

local recent_projects = {
    type = "group",
    val = function()
        local projs = get_recent_projects()
        if #projs == 0 then
            return {
                { type = "text", val = "  Nessun progetto recente", opts = { position = "center", hl = "AlphaFooter" } },
            }
        end
        return vim.list_extend(
            { { type = "text", val = "  Progetti recenti", opts = { position = "center", hl = "AlphaShortcut" } } },
            projs
        )
    end,
    opts = { spacing = 0 },
}

-- ============================================================
-- 4. Voci del menu
-- ============================================================
local function button(sc, icon, txt, keycmd)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
    return {
        type   = "button",
        val    = icon .. "  " .. txt,
        on_press = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keycmd, true, false, true), "t", false)
        end,
        opts = {
            position       = "center",
            shortcut       = "[" .. sc .. "]",
            cursor         = 3,
            width          = 52,
            align_shortcut = "right",
            hl             = "AlphaButton",
            hl_shortcut    = "AlphaShortcut",
            keymap = {
                "n", sc_,
                keycmd,
                { noremap = true, silent = true, nowait = true },
            },
        },
    }
end

local buttons = {
    type = "group",
    val = {
        { type = "text", val = "  Azioni", opts = { position = "center", hl = "AlphaShortcut" } },
        button("n", "󰈔", "Nuovo file",      ":ene <BAR> startinsert<CR>"),
        button("f", "󰱼", "Trova file",     ":lua require('fzf-lua').files()<CR>"),
        button("e", "󰙅", "Esplora file",   ":NvimTreeToggle<CR>"),
        button("g", "󰱼", "Cerca testo",    ":lua require('fzf-lua').live_grep()<CR>"),
        button("l", "󰊢", "Git",            ":LazyGit<CR>"),
        button("d", "󰡨", "Docker",         ":Lazydocker<CR>"),
        button("o", "󱙺", "OpenCode",       ":lua require('opencode').toggle()<CR>"),
        button("c", "󰒓", "Configurazione", ":e ~/Dotfiles/nvim/ | cd ~/Dotfiles/nvim/<CR>"),
        button("k", "󰌌", "Shortcut",       ":e ~/.config/nvim/KEYMAPS.md<CR>"),
        button("u", "󰒲", "Aggiorna plugin",":Lazy sync<CR>"),
        button("q", "󰅚", "Esci",           ":qa<CR>"),
    },
    opts = { spacing = 0 },
}

-- ============================================================
-- 6. Footer con statistiche plugin
-- ============================================================
local function footer()
    local stats   = require("lazy").stats()
    local ms      = math.floor(stats.startuptime * 100 + 0.5) / 100
    local version = vim.version()
    return string.format(
        "󱐋 neovim v%d.%d.%d   ·  󰏗 %d plugin caricati in %s ms",
        version.major, version.minor, version.patch,
        stats.loaded, ms
    )
end

local footer_section = {
    type = "text",
    val  = footer(),
    opts = { position = "center", hl = "AlphaFooter" },
}

-- ============================================================
-- 7. Padding helper
-- ============================================================
local function pad(n)
    return { type = "padding", val = n }
end

-- ============================================================
-- 8. Layout finale
-- ============================================================
alpha.setup({
    layout = {
        pad(1),
        header,
        pad(1),
        recent_files,
        pad(1),
        recent_projects,
        pad(1),
        buttons,
        pad(1),
        footer_section,
    },
    opts = { margin = 5 },
})

-- ============================================================
-- 9. Highlight groups (Nord palette)
-- ============================================================
local function set_alpha_highlights()
    vim.api.nvim_set_hl(0, "AlphaHeader",   { fg = "#81A1C1", bold = true })
    vim.api.nvim_set_hl(0, "AlphaButton",   { fg = "#D8DEE9" })
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#8FBCBB", bold = true })
    vim.api.nvim_set_hl(0, "AlphaFooter",   { fg = "#616E88", italic = true })
    vim.api.nvim_set_hl(0, "AlphaFolder",   { fg = "#EBCB8B", bold = true })  -- giallo Nord
end

set_alpha_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_alpha_highlights })

-- ============================================================
-- 10. Chiudi alpha con q
-- ============================================================
vim.api.nvim_create_autocmd("User", {
    pattern  = "AlphaReady",
    callback = function()
        vim.keymap.set("n", "q", ":q<CR>", { buffer = true, silent = true })
    end,
})
