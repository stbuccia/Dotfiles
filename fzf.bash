# Setup fzf
# ---------
if [[ ! "$PATH" == */home/PERSONALE/stefano.bucciarelli3/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/PERSONALE/stefano.bucciarelli3/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/PERSONALE/stefano.bucciarelli3/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/PERSONALE/stefano.bucciarelli3/.fzf/shell/key-bindings.bash"
