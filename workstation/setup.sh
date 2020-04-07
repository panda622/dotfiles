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

# check python for neovim
# if pip3 list | grep -q neovim; then
# 	echo "===> Installing pip3 neovim"
# 	pip3 install neovim
# fi

# install 1password
if ! [ -x "$(command -v op)" ]; then
	echo "===> Installing 1password"
	export OP_VERSION="v0.9.4"
	curl -sS -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/${OP_VERSION}/op_linux_amd64_${OP_VERSION}.zip
	unzip 1password.zip op -d /usr/local/bin
	rm -f 1password.zip
fi

if [ ! -d "~/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm" && (
	git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
	cd "$NVM_DIR"
	git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
	) && \. "$NVM_DIR/nvm.sh"
	echo "===> Installing nodejs"
	nvm install node
fi

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
    git clone "https://github.com/neoclide/coc.nvim"
	git clone "https://github.com/SirVer/ultisnips"
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
  git clone https://github.com/zsh-users/zsh-completions "${HOME}/.zsh/zsh-completions"
fi

if [ ! -d "$HOME/dotfiles" ]; then
  echo "==> Setting up dotfiles"
  cd "$HOME"
  git clone --recursive https://github.com/panda622/dotfiles.git

  cd "$HOME/dotfiles"
  # git remote set-url origin git@github.com:panda622/dotfiles.git

  mkdir -p "$HOME/.config/nvim"
  ln -sfn $(pwd)/.vimrc "${HOME}/.config/nvim/init.vim"
  ln -sfn $(pwd)/.zshrc "${HOME}/.zshrc"
  ln -sfn $(pwd)/.tmux.conf "${HOME}/.tmux.conf"
  ln -sfn $(pwd)/.gitconfig "${HOME}/.gitconfig"
  ln -sfn $(pwd)/.ctags "${HOME}/.ctags"
fi

chsh -s /bin/zsh
