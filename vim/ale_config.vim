" Enable ALE
let g:ale_enabled = 1

" Set the linters for specific file types
let g:ale_linters = {
\   'php': ['phpcs', 'phpstan'],
\   'html': ['htmlhint'],
\   'css': ['stylelint'],
\   'javascript': ['eslint'],
\}

" Set the fixers for specific file types
let g:ale_fixers = {
\   'php': ['phpcbf'],
\   'html': ['htmlbeautifier'],
\   'css': ['stylelint'],
\   'javascript': ['eslint'],
\}

" Enable auto-fixing on save
"let g:ale_fix_on_save = 1

" Show linting messages in the sign column
let g:ale_sign_column_always = 1

" Set the display of errors and warnings
let g:ale_echo_msg_error_str = 'E:'
let g:ale_echo_msg_warning_str = 'W:'
