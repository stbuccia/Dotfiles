# Setup fzf
# ---------
if [[ ! "$PATH" == */home/stefano/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/stefano/.fzf/bin"
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --reverse'
#export FZF_ALT_C_COMMAND='locate .'
# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/stefano/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/stefano/.fzf/shell/key-bindings.bash"

## fzf completation
# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

