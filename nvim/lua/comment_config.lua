-- require('Comment').setup()

-- Configurazione indentazione per file PHP
vim.bo.autoindent = true
vim.bo.smartindent = false  -- Disabilita smartindent per PHP
vim.bo.cindent = false  -- Disabilita cindent che può interferire

-- Carica esplicitamente il file di indent PHP
vim.cmd('runtime! indent/php.vim')

-- Imposta l'indentexpr per PHP
vim.bo.indentexpr = 'GetPhpIndent()'

-- Imposta i caratteri che triggano il re-indent
vim.bo.indentkeys = '0{,0},0),0],:,!^F,o,O,e'


vim.opt.autoindent    = true
