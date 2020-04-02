#!/bin/bash

set -eu
pacman --noconfirm -Syu

pacman --noconfirm -S \
	git \
	ctags \
	zsh \
	tmux \
	neovim \
	the_silver_searcher \
	fzf \
	unzip \
	mosh \
	python \
	python-pip \
	docker \
	docker-compose \

echo "===> Installing pip3 neovim"
pip3 install neovim

VIM_PLUG_FILE="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  mkdir -p "${HOME}/.config/nvim/plugged"
  pushd "${HOME}/.config/nvim/plugged"
    git clone "https://github.com/junegunn/fzf"
    git clone "https://github.com/junegunn/fzf.vim"
    git clone "https://github.com/tpope/vim-surround"
    git clone "https://github.com/tpope/vim-repeat"
    git clone "https://github.com/tpope/vim-commentary"
    git clone "https://github.com/tpope/vim-fugitive"
    git clone "https://github.com/preservim/nerdtree"
    git clone "https://github.com/Xuyuanp/nerdtree-git-plugin"
    git clone "https://github.com/prettier/vim-prettier"
    git clone "https://github.com/neoclide/coc.nvim"
    git clone "https://github.com/SirVer/ultilsnips"
    git clone "https://github.com/honza/vim-snippets"
    git clone "https://github.com/majutsushi/tagbar"
    git clone "https://github.com/ludovicchabant/vim-gutentags"
    git clone "https://github.com/mcchrish/nnn.vim"

    git clone "https://github.com/ryanoasis/vim-devicons"
    git clone "https://github.com/Yggdroot/indentLine"
    git clone "https://github.com/sheerun/vim-polyglot"
    git clone "https://github.com/morhetz/gruvbox"
  popd
fi

if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
fi

if [ ! -d "$HOME/dotfiles" ]; then
  echo "==> Setting up dotfiles"
  cd "$HOME"
  git clone --recursive https://github.com/panda622/dotfiles.git

  cd "$HOME/dotfiles"
  git remote set-url origin git@github.com:panda622/dotfiles.git

  mkdir -p "$HOME/.config/nvim"
  ln -sfn $(pwd)/.vimrc "${HOME}/.config/nvim/init.vim"
  ln -sfn $(pwd)/.zshrc "${HOME}/.zshrc"
  ln -sfn $(pwd)/.tmux.conf "${HOME}/.tmux.conf"
  ln -sfn $(pwd)/.gitconfig "${HOME}/.gitconfig"
  ln -sfn $(pwd)/.ctags "${HOME}/.ctags"
fi

chsh -s /bin/zsh
