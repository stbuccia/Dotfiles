# Setup fzf
# ---------
if [[ ! "$PATH" == */home/stefano/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/stefano/.fzf/bin"
fi

eval "$(fzf --bash)"
