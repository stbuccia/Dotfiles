#!/bin/bash

#rimuovo i file vecchi
rm ~/.vimrc
rm -rf ~/vim
rm ~/.bashrc

#li ricostruisco facendo dei link simbolici
ln -s ~/Dotfiles/vim ~/.vim
ln -s ~/Dotfiles/bashrc ~/.bashrc

#installa vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#installa fzf
[[ -d $HOME/.fzf ]] || (echo "Installing fzf... " && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)

#mette vim come editor predefinito
xdg-mime default vim.desktop text/*
