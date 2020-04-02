#!/bin/bash
rm -rf ~/.vimrc
rm -rf ~/.zshrc
rm -rf ~/.gitconfig
rm -rf ~/.ctags
rm -rf ~/.tmux.conf
rm -rf ~/.config/polybar
rm -rf ~/.config/i3
rm -rf ~/.config/nvim

mkdir -p "${HOME}/.config/polybar"
mkdir -p "${HOME}/.config/i3"
mkdir -p "${HOME}/.config/nvim"

ln -sfn $(pwd)/.config/i3/config "${HOME}/.config/i3/config"
ln -sfn $(pwd)/.config/polybar/* "${HOME}/.config/polybar"

ln -sfn $(pwd)/.vimrc "${HOME}/.config/nvim/init.vim"
ln -sfn $(pwd)/.zshrc "${HOME}/.zshrc"
ln -sfn $(pwd)/.tmux.conf "${HOME}/.tmux.conf"
ln -sfn $(pwd)/.gitconfig "${HOME}/.gitconfig"
ln -sfn $(pwd)/.ctags "${HOME}/.ctags"
