# Setup fzf
# ---------
if [[ ! "$PATH" == */home/stefano/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/stefano/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/stefano/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/stefano/.fzf/shell/key-bindings.bash"
