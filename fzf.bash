# Setup fzf
# ---------
if [[ ! "$PATH" == */home/buccia/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/buccia/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/buccia/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/buccia/.fzf/shell/key-bindings.bash"
