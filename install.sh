#!/bin/bash

#rimuovo i file vecchi
rm ~/.vimrc
rm -rf ~/vim
rm ~/.bashrc
rm ~/.i3/config

#li ricostruisco facendo dei link simbolici
ln -s ~/Dotfiles/vim ~/.vim
ln -s ~/Dotfiles/bashrc ~/.bashrc

#installa vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Open vim and digit ':PlugInstall'"

#installa fzf
[[ -d $HOME/.fzf ]] || (echo "Installing fzf... " && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)

#configurazione i3
if [ "$DESKTOP_SESSION" = "i3" ]; then
    # i3 config
    ln -s ~/Dotfiles/i3/i3.conf ~/.i3/config
    i3 reload
    # i3 blocks config
    ln -s ~/Dotfiles/i3/i3blocks.conf ~/.i3blocks/config
    i3blocks -c ~/.i3blocks/config
    i3-msg restart
    # download i3 scripts
    git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks
    cd !$
    for i in * 
    do
        chmod +x "$i"/"$i" 
    done
    make install
    cd ..
    rm -rf i3blocks
    i3-msg restart
fi
#mette vim come editor predefinito
xdg-mime default vim.desktop text/*

