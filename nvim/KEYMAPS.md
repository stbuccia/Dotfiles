# Neovim — Shortcut e Comandi

> `<leader>` = `Spazio`

---

## Navigazione file

| Shortcut | Azione |
|---|---|
| `<C-n>` | Apri/chiudi file explorer (nvim-tree) |
| `<leader>nf` | Trova il file corrente nell'explorer |

---

## fzf-lua

| Shortcut | Azione |
|---|---|
| `<C-p>` | Trova file nel progetto |
| `<leader>fg` | Live grep con ripgrep |
| `<leader>fd` | Live grep in una directory specifica (selettore interattivo) |
| `<leader>fb` | Buffer aperti |
| `<leader>fr` | File recenti |
| `<leader>fw` | Cerca la parola sotto il cursore |
| `<leader>fs` | Simboli LSP del file corrente |
| `<leader>fh` | Help tags di Neovim |

---

## LSP (attivo su file con server configurato)

| Shortcut | Azione |
|---|---|
| `gd` | Vai alla definizione |
| `gy` | Vai alla definizione del tipo |
| `gi` | Vai all'implementazione |
| `gr` | Lista riferimenti |
| `K` | Documentazione hover |
| `<leader>rn` | Rinomina simbolo |
| `<leader>ac` | Code action (fix, refactoring) |
| `ga` | Code action (alias) |
| `<leader>f` | Formatta il file/selezione |
| `<leader>oi` | Organizza import |

> **PHP**: due server in parallelo — `intelephense` (completamento + diagnostica) + `phpactor` (code actions e refactoring)

### Server LSP configurati

| Server | Linguaggio |
|---|---|
| `intelephense` | PHP |
| `phpactor` | PHP (code actions) |
| `ts_ls` | TypeScript / JavaScript |
| `jsonls` | JSON |
| `html` | HTML |
| `cssls` | CSS / SCSS / Less |

---

## Diagnostica

| Shortcut | Azione |
|---|---|
| `[g` | Diagnostica precedente |
| `]g` | Diagnostica successiva |
| `<leader>d` | Apri finestra float con dettaglio errore |
| `<leader>q` | Apri lista diagnostica (quickfix) |

---

## Autocompletamento (nvim-cmp)

| Shortcut | Azione |
|---|---|
| `<C-Space>` | Forza apertura menu completamento |
| `<C-j>` / `<Tab>` | Voce successiva |
| `<C-k>` / `<S-Tab>` | Voce precedente |
| `<CR>` | Conferma selezione |
| `<C-e>` | Chiudi menu |
| `<C-b>` / `<C-f>` | Scrolla documentazione su/giù |

> Sorgenti attive (in ordine di priorità): Copilot → LSP → LuaSnip snippets → Buffer → Path

---

## Git — LazyGit

| Shortcut / Comando | Azione |
|---|---|
| `<leader>lg` | Apri LazyGit |
| `:LazyGit` | Apri LazyGit |
| `:LazyGitCurrentFile` | Apri LazyGit sul file corrente |

---

## Copilot

| Comando | Azione |
|---|---|
| `:Copilot enable` | Abilita Copilot |
| `:Copilot disable` | Disabilita Copilot |
| `:CopilotChat` | Apri chat con Copilot |

---

## Plugin manager — Lazy.nvim

| Comando | Azione |
|---|---|
| `:Lazy` | Apri UI Lazy |
| `:Lazy sync` | Installa/aggiorna/rimuovi plugin |
| `:Lazy update` | Aggiorna plugin |

---

## Mason (LSP installer)

| Comando | Azione |
|---|---|
| `:Mason` | Apri UI Mason |
| `:MasonInstall <server>` | Installa un server LSP |

---

## Varie

| Shortcut / Comando | Azione |
|---|---|
| `<leader>?` | Apri questo file |
| `<leader>C` | Apri cartella configurazione Neovim |
| `<C-Backspace>` (insert) | Cancella parola precedente |
| `:Format` | Formatta il buffer via LSP |
| `:OR` | Organizza import via LSP |
