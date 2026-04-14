-- Abilita true‑color se il terminale lo supporta
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end

-- Imposta il colorscheme solo su Neovim
if vim.fn.has('nvim') == 1 then
  vim.cmd('colorscheme nord')   -- oppure 'OceanicNext' se preferisci
end

-- Abilita la sintassi (funziona sia in Vim che in Neovim)
vim.cmd('syntax enable')

