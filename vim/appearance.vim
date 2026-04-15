if (has("termguicolors"))
 set termguicolors
endif
"color theme (available only for neovim)
"colorscheme OceanicNext
if !has('nvim')
    colorscheme nord
endif
""color theme (available only for neovim)
syntax enable

" ============================================================
" Pmenu highlights (Nord palette)
" Sovrascrive i colori di default dopo il colorscheme per
" garantire che il menu di completamento sia sempre visibile.
" ============================================================
function! s:SetPmenuHighlights()
    " Sfondo del popup: grigio-blu scuro Nord, distinto da Normal (#2e3440)
    highlight Pmenu      guifg=#D8DEE9 guibg=#3B4252
    " Voce selezionata: blu Nord accent
    highlight PmenuSel   guifg=#ECEFF4 guibg=#5E81AC gui=bold
    " Scrollbar
    highlight PmenuSbar  guibg=#434C5E
    highlight PmenuThumb guibg=#81A1C1
endfunction

call s:SetPmenuHighlights()

" Riapplica dopo ogni cambio di colorscheme
augroup PmenuHighlights
    autocmd!
    autocmd ColorScheme * call s:SetPmenuHighlights()
augroup END
