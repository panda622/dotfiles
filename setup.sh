#!/bin/bash

sudo pacman -S --noconfirm zsh docker docker-compose fzf neovim tmux git ctags the_silver_searcher mosh htop nnn unzip rclone lazygit
sudo pacman -S --needed base-devel git wget yajl

# Docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service

# Yaourt

if ! [-x "$(command yaourt)"]; then
	cd /tmp
	git clone https://aur.archlinux.org/package-query.git
	cd package-query/
	makepkg -si && cd /tmp/
	git clone https://aur.archlinux.org/yaourt.git
	cd yaourt/
	makepkg -si
fi

# Nvm
if ! [ -x "$(command -v node)" ]; then
  echo "==> Setting NVM and NODE"
	export NVM_DIR="$HOME/.nvm" && (
	git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
	cd "$NVM_DIR"
	git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
	) && \. "$NVM_DIR/nvm.sh"
	echo "===> Installing nodejs"
	nvm install node
	npm install -g yarn
fi

# Oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  echo "==> Setting oh-my-zsh"
  yes Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

rm -rf ~/.vimrc
rm -rf ~/.zshrc
rm -rf ~/.gitconfig
rm -rf ~/.ctags
rm -rf ~/.tmux.conf
rm -rf ~/.config/nvim
rm -rf ~/.agignore

mkdir -p "${HOME}/.config/nvim"

ln -sfn ~/dotfiles/.vimrc "${HOME}/.config/nvim/init.vim"
ln -sfn ~/dotfiles/UltiSnips "${HOME}/.config/nvim/UltiSnips"
ln -sfn ~/dotfiles/.zshrc "${HOME}/.zshrc"
ln -sfn ~/dotfiles/.tmux.conf "${HOME}/.tmux.conf"
ln -sfn ~/dotfiles/.gitconfig "${HOME}/.gitconfig"
ln -sfn ~/dotfiles/.ctags "${HOME}/.ctags"
ln -sfn ~/dotfiles/.agignore "${HOME}/.agignore"
