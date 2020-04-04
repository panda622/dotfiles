#!/bin/bash
rm -rf ~/.vimrc
rm -rf ~/.zshrc
rm -rf ~/.gitconfig
rm -rf ~/.ctags
rm -rf ~/.tmux.conf
rm -rf ~/.config/polybar
rm -rf ~/.config/i3
rm -rf ~/.config/nvim

mkdir -p "${HOME}/.config/nvim"


ln -sfn ~/dotfiles/.vimrc "${HOME}/.config/nvim/init.vim"
ln -sfn ~/dotfiles/.zshrc "${HOME}/.zshrc"
ln -sfn ~/dotfiles/.tmux.conf "${HOME}/.tmux.conf"
ln -sfn ~/dotfiles/.gitconfig "${HOME}/.gitconfig"
ln -sfn ~/dotfiles/.ctags "${HOME}/.ctags"

case `uname` in
  Darwin)
  ;;
  Linux)
	mkdir -p "${HOME}/.config/polybar"
	mkdir -p "${HOME}/.config/i3"
	ln -sfn $(pwd)/.config/i3/config "${HOME}/.config/i3/config"
	find $(pwd)/.config/polybar -maxdepth 1  -type d -exec ln -sf $HOME/.config/polybar {} \;
  ;;
esac
