#~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export EDITOR=vim
# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u \[\033[01;34m\]\w\[\033[00m\] '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w > \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\w '
fi
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w > \[\033[00m\]'
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# functions
is_distro_name(){
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
    fi
    matches=$(echo $OS | grep --ignore-case $1 | wc -l)
    echo $matches
    if [[ $matches == "0" ]]; then
        return 0 
    else
        return 1 
    fi

}
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias android-emulator='~/Android/Sdk/emulator/emulator -avd Pixel_API_26 -use-system-libs'
alias android-studio='~/Software/android-studio/bin/studio.sh'
if [ $(is_distro_name debian) == 1 ]; then
    alias fd='fdfind'
elif [ $(is_distro_name pop) == 1 ]; then
    alias fd='fdfind'
elif [ $(is_distro_name manjaro) == 1 ]; then
    alias fdfind='fd'
fi
alias o='xdg-open'
alias of='xdg-open `fzf`'
alias vi='vim'
alias todo='todo.sh'
if [ $(is_distro_name manjaro) == 1 ]; then
    alias pacman-fzf="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
fi

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


PATH=$PATH":$HOME/.local/bin"

#wanda il pesce
fortune

export PATH=/home/stefano/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/snap/bin:/home/stefano/.local/bin:/home/stefano/.vimpkg/bin:$HOME/Utilities/omnetpp/bin:/home/stefano/Utilities/omnet/bin:/sbin:/usr/sbin:/home/stefano/.cargo/bin

#set -o vi

#evita il Fontconfig error
export FONTCONFIG_PATH=/etc/fonts

export FZF_DEFAULT_COMMAND='fd --hidden'

#fzf con fd
if [ $(is_distro_name debian) == 1 ]; then
    export FZF_DEFAULT_COMMAND='fdfind --hidden'
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# OPAM configuration
. /home/stefano/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export LANGUAGE=en_US.UTF-8

# Shell options {{{
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s direxpand
shopt -s dirspell
shopt -s extglob
shopt -s globstar
shopt -s histappend
# }}}


# Keybindings {{{
bind C-e:menu-complete
bind C-p:fzf-passc

# }}}

#set vi 
set -o vi
export EDITOR=vim

# set thefuck

eval "$(thefuck --alias)"
alias rum='fuck'

#EMOJI
set emoji on prompt

TERMINAL_NAME=$(ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$))
if [ "$TERMINAL_NAME" = "kitty" ]; then
    if [ "$EUID" -ne 0 ]; then
        PS1="\`if [[ \$? = '0' ]]; then echo '⚓ '; else echo '☠️ '; fi\`"$PS1
    else
        PS1="\`if [[ \$? = '0' ]]; then echo '🔱 '; else echo '🌊'; fi\`"$PS1
    fi
else
    if [ "$EUID" -ne 0 ]; then
        PS1="\`if [[ \$? = '0' ]]; then echo '⚓ '; else echo '☠️  '; fi\`"$PS1
    else
        PS1="\`if [[ \$? = '0' ]]; then echo '🔱 '; else echo '🌊 '; fi\`"$PS1
    fi
fi

. .emoji-alias.bash

export TNS_ADMIN=/etc
export LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib
export ORACLE_BASE=/usr/lib/oracle/21/client64
export ORACLE_HOME=/usr/lib/oracle/21/client64/

