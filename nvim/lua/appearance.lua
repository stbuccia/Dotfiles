-- Abilita true‑color se il terminale lo supporta
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end

-- Imposta il colorscheme solo su Neovim
if vim.fn.has('nvim') == 1 then
  vim.cmd('colorscheme nord')
end

-- Abilita la sintassi (funziona sia in Vim che in Neovim)
vim.cmd('syntax enable')

-- ============================================================
-- Pmenu / nvim-cmp popup highlights
-- Sfondo distinto + bordo visibile su qualsiasi colorscheme.
-- ============================================================
local function set_cmp_highlights()
    -- Legge il bg del tema corrente per calcolare un contrasto sicuro
    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local bg = normal_hl.bg  -- valore numerico (es. 0x2e3440) o nil se terminale

    -- Se il tema è scuro (o bg non definito) usa un grigio chiaro per il popup,
    -- altrimenti usa un grigio scuro.
    local is_dark = vim.o.background == "dark"
    local pmenu_bg  = is_dark and "#404859" or "#e8e8e8"
    local pmenu_fg  = is_dark and "#ECEFF4" or "#1e1e2e"
    local sel_bg    = is_dark and "#6b7a96" or "#c0caf5"
    local sel_fg    = is_dark and "#ECEFF4" or "#1e1e2e"
    local border_fg = is_dark and "#88C0D0" or "#7aa2f7"

    vim.api.nvim_set_hl(0, "Pmenu",       { fg = pmenu_fg, bg = pmenu_bg })
    vim.api.nvim_set_hl(0, "PmenuSel",    { fg = sel_fg,   bg = sel_bg, bold = true })
    vim.api.nvim_set_hl(0, "PmenuSbar",   { bg = is_dark and "#3a3f4b" or "#d0d0d0" })
    vim.api.nvim_set_hl(0, "PmenuThumb",  { bg = border_fg })
    -- Finestre flottanti (usate da nvim-cmp bordered())
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = pmenu_fg, bg = pmenu_bg })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_fg, bg = pmenu_bg })

    -- Bordi della finestra bordered() di nvim-cmp
    vim.api.nvim_set_hl(0, "CmpBorder",    { fg = border_fg })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = is_dark and "#565f89" or "#9899a6" })

    -- Kind icons (colori per tipo di completamento)
    vim.api.nvim_set_hl(0, "CmpItemKindText",          { fg = "#D8DEE9" })
    vim.api.nvim_set_hl(0, "CmpItemKindMethod",        { fg = "#88C0D0" })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction",      { fg = "#88C0D0" })
    vim.api.nvim_set_hl(0, "CmpItemKindConstructor",   { fg = "#8FBCBB" })
    vim.api.nvim_set_hl(0, "CmpItemKindField",         { fg = "#81A1C1" })
    vim.api.nvim_set_hl(0, "CmpItemKindVariable",      { fg = "#D8DEE9" })
    vim.api.nvim_set_hl(0, "CmpItemKindClass",         { fg = "#EBCB8B" })
    vim.api.nvim_set_hl(0, "CmpItemKindInterface",     { fg = "#EBCB8B" })
    vim.api.nvim_set_hl(0, "CmpItemKindModule",        { fg = "#EBCB8B" })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty",      { fg = "#81A1C1" })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword",       { fg = "#B48EAD" })
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet",       { fg = "#A3BE8C" })
    vim.api.nvim_set_hl(0, "CmpItemKindColor",         { fg = "#BF616A" })
    vim.api.nvim_set_hl(0, "CmpItemKindFile",          { fg = "#D8DEE9" })
    vim.api.nvim_set_hl(0, "CmpItemKindReference",     { fg = "#81A1C1" })
    vim.api.nvim_set_hl(0, "CmpItemKindFolder",        { fg = "#EBCB8B" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum",          { fg = "#EBCB8B" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember",    { fg = "#A3BE8C" })
    vim.api.nvim_set_hl(0, "CmpItemKindConstant",      { fg = "#D08770" })
    vim.api.nvim_set_hl(0, "CmpItemKindStruct",        { fg = "#EBCB8B" })
    vim.api.nvim_set_hl(0, "CmpItemKindOperator",      { fg = "#81A1C1" })
    vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#8FBCBB" })
    -- Copilot nel menu
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot",       { fg = "#A3BE8C" })

    -- Testo abbinato (match) evidenziato
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",         { fg = "#88C0D0", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",    { fg = "#88C0D0", bold = true })
    -- Testo non selezionato leggermente attenuato
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated",    { fg = "#616E88", strikethrough = true })
end

set_cmp_highlights()

-- Riapplica dopo ogni cambio di colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern  = "*",
    callback = set_cmp_highlights,
})

