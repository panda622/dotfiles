#!/bin/bash

mkdir -p "${HOME}/.config/nvim"
ln -sfn $(pwd)/vimrc "${HOME}/.config/nvim/init.vim"
ln -sfn $(pwd)/zshrc "${HOME}/.zshrc"
ln -sfn $(pwd)/tmux.conf "${HOME}/.tmux.conf"
ln -sfn $(pwd)/gitconfig "${HOME}/.gitconfig"
