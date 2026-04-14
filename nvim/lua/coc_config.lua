-- ----------------------------------------------------------------------
-- 1 Estensioni globali da installare
-- ----------------------------------------------------------------------

vim.g.coc_global_extensions = {
  'coc-snippets',
  'coc-pairs',
  'coc-tsserver',
  'coc-eslint',
  'coc-prettier',
  'coc-json',
  'coc-html',
  'coc-css',
  'coc-phpls',
}

-- ----------------------------------------------------------------------
-- 2 Opzioni di base (Vim + Neovim)
-- ----------------------------------------------------------------------
vim.o.encoding   = 'utf-8'      -- solo per Vim, Neovim usa UTF‑8 di default
vim.o.hidden     = true
vim.o.backup     = false
vim.o.writebackup = false
vim.o.cmdheight  = 2
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. 'c'   -- non mostra messaggi al completamento

-- ----------------------------------------------------------------------
-- 3 Signcolumn: mantiene le colonne separate per evitare sovrapposizioni
-- ----------------------------------------------------------------------
vim.o.signcolumn = 'yes'   -- colonna sempre visibile per segni git/diagnostici

-- ----------------------------------------------------------------------
-- 4 Mappature per il completamento (inserimento)
-- ----------------------------------------------------------------------
local opts = { noremap = true, silent = true, expr = true }

vim.api.nvim_set_keymap('i', '<C-j>',
  'coc#pum#visible() ? coc#pum#next(1) : "<C-j>"', opts)
vim.api.nvim_set_keymap('i', '<C-k>',
  'coc#pum#visible() ? coc#pum#prev(1) : "<C-k>"', opts)

vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()]], opts)
vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<C-h>"]], opts)

if vim.fn.has('nvim') == 1 then
  vim.api.nvim_set_keymap('i', '<C-space>', 'coc#refresh()', opts)
else
  vim.api.nvim_set_keymap('i', '<C-@>', 'coc#refresh()', opts)
end

vim.api.nvim_set_keymap('i', '<CR>',
  [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- ----------------------------------------------------------------------
-- 5 Funzione di supporto per il Tab
-- ----------------------------------------------------------------------
function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

-- ----------------------------------------------------------------------
-- 6 Mappature per la navigazione tra diagnosi e riferimenti
-- ----------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { noremap = true, silent = true })

-- ----------------------------------------------------------------------
-- 7 Navigazione del codice (normal mode)
-- ----------------------------------------------------------------------   
local nmap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

nmap('gd', '<Plug>(coc-definition)')
nmap('gy', '<Plug>(coc-type-definition)')
nmap('gi', '<Plug>(coc-implementation)')
nmap('gr', '<Plug>(coc-references)')

-- ----------------------------------------------------------------------
-- 8 Documentazione (normal mode, con K)
-- ----------------------------------------------------------------------
vim.api.nvim_set_keymap('n', 'K', ':lua ShowDocumentation()<CR>', { noremap = true, silent = true })

function ShowDocumentation()
  local ft = vim.bo.filetype
  if ft == 'vim' or ft == 'help' then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  elseif vim.fn['coc#rpc#ready']() == 1 then
    vim.fn.CocActionAsync('doHover')
  else
    vim.cmd('!' .. vim.o.keywordprg .. ' ' .. vim.fn.expand('<cword>'))
  end
end

-- ----------------------------------------------------------------------
-- 9️⃣ Evidenziazione simboli al fermo del cursore
-- ----------------------------------------------------------------------
vim.cmd('autocmd CursorHold * silent call CocActionAsync("highlight")')

-- ----------------------------------------------------------------------
-- 10 Rinomina, formattazione e code‑action (modalità normal e visual)
-- ----------------------------------------------------------------------
-- Rinomina
vim.api.nvim_set_keymap('n', '<leader>rn', '<Plug>(coc-rename)', { noremap = true, silent = true })

-- Formattazione
vim.api.nvim_set_keymap('x', '<leader>f', '<Plug>(coc-format-selected)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>(coc-format-selected)', { noremap = true, silent = true })

-- Code actions su selezione
vim.api.nvim_set_keymap('x', '<leader>a', '<Plug>(coc-codeaction-selected)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', '<Plug>(coc-codeaction-selected)', { noremap = true, silent = true })

-- Code action su buffer intero
vim.api.nvim_set_keymap('n', '<leader>ac', '<Plug>(coc-codeaction)', { noremap = true, silent = true })

-- Code action su cursore
vim.api.nvim_set_keymap('n', 'ga', '<Plug>(coc-codeaction-cursor)', { noremap = true, silent = true })

-- Auto‑fix della riga corrente
vim.api.nvim_set_keymap('n', '<leader>qf', '<Plug>(coc-fix-current)', { noremap = true, silent = true })

-- Azione CodeLens
vim.api.nvim_set_keymap('n', '<leader>al', '<Plug>(coc-codelens-action)', { noremap = true, silent = true })

-- ----------------------------------------------------------------------
-- 11 Scrolling nei float/popup (solo se supportato)
-- ----------------------------------------------------------------------
if vim.fn.has('nvim-0.4.0') == 1 or vim.fn.has('patch-8.2.0750') == 1 then
local scroll_opts = { noremap = true, silent = true, expr = true, nowait = true }
vim.api.nvim_set_keymap('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scroll_opts)
vim.api.nvim_set_keymap('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scroll_opts)
vim.api.nvim_set_keymap('i', '<C-f>', 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(1)\\<cr>" : "\\<Right>"', scroll_opts)
vim.api.nvim_set_keymap('i', '<C-b>', 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(0)\\<cr>" : "\\<Left>"', scroll_opts)
vim.api.nvim_set_keymap('v', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scroll_opts)
vim.api.nvim_set_keymap('v', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scroll_opts)
end

-- ----------------------------------------------------------------------
-- 12 Selezione di range (Ctrl‑S)
-- ----------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '<C-s>', '<Plug>(coc-range-select)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<C-s>', '<Plug>(coc-range-select)', { noremap = true, silent = true })

-- ----------------------------------------------------------------------
-- 13 Comandi personalizzati
-- ----------------------------------------------------------------------
vim.cmd('command! -nargs=0 Format  lua vim.fn.CocActionAsync("format")')
vim.cmd('command! -nargs=? Fold    lua vim.fn.CocAction("fold", <f-args>)')
vim.cmd('command! -nargs=0 OR      lua vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")')

-- ----------------------------------------------------------------------
-- 14 Integrazione nella statusline
-- ----------------------------------------------------------------------
vim.o.statusline = vim.o.statusline .. '%{coc#status()}%{get(b:,"coc_current_function","")}'

-- ----------------------------------------------------------------------
-- 15  Mappature per CocList
-- ----------------------------------------------------------------------
local function map_coclist(lhs, cmd)
  vim.api.nvim_set_keymap('n', lhs,
    ':<C-u>' .. cmd .. '<CR>', { noremap = true, silent = true, nowait = true })
end

map_coclist('<Space>a', 'CocList diagnostics')
map_coclist('<Space>e', 'CocList extensions')
map_coclist('<Space>c', 'CocList commands')
map_coclist('<Space>o', 'CocList outline')
map_coclist('<Space>s', 'CocList -I symbols')
map_coclist('<Space>j', 'CocNext')
map_coclist('<Space>k', 'CocPrev')
map_coclist('<Space>p', 'CocListResume')

-- ----------------------------------------------------------------------
-- 16 Shortcut per comandi CoC specifici
-- ----------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '<leader>e', ':CocCommand explorer<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':CocCommand fzf-preview.CommandPalette<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':CocCommand fzf-preview.ProjectFiles<CR>', { noremap = true, silent = true })

-- ----------------------------------------------------------------------
-- 17 Integrazione con Vista (se installata)
-- ----------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '<leader>vc', ':Vista coc<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vf', ':Vista finder<CR>', { noremap = true, silent = true })

-- ----------------------------------------------------------------------
-- 18 Autocomandi specifici per filetype
-- ----------------------------------------------------------------------
vim.api.nvim_create_augroup('coc_mygroup', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'coc_mygroup',
  pattern = { 'typescript', 'json' },
  command = 'setlocal formatexpr=CocAction("formatSelected")',
})
vim.api.nvim_create_autocmd('User', {
  group = 'coc_mygroup',
  pattern = 'CocJumpPlaceholder',
  command = 'call CocActionAsync("showSignatureHelp")',
})


