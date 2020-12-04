#!/bin/bash
# Ref: https://github.com/fatih/dotfiles/blob/master/bootstrap.sh
set -eu

export DEBIAN_FRONTEND=noninteractive

UPGRADE_PACKAGES=${1:-none}

if [ "${UPGRADE_PACKAGES}" != "none" ]; then
  echo "==> Updating and upgrading packages ..."
  # Add third party repositories
  add-apt-repository ppa:keithw/mosh-dev -y
  apt-get update
  apt-get upgrade -y
fi

apt-get install -qq \
  git \
  ctags \
  zsh \
  tmux \
  neovim \
  silversearcher-ag \
  fzf \
  unzip \
  mosh \
  htop \
  nnn \
  --no-install-recommends \

rm -rf /var/lib/apt/lists/*


# Install npm
if ! [ -x "$(command -v node)" ]; then
	export NVM_DIR="$HOME/.nvm" && (
	git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
	cd "$NVM_DIR"
	git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
	) && \. "$NVM_DIR/nvm.sh"
	echo "===> Installing nodejs"
	nvm install node
	npm install -g yarn
fi

# Install docker
if ! [ -x "$(command -v docker)" ]; then
  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io

  curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
fi

# Neovim and Vim Plug
VIM_PLUG_FILE="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  mkdir -p "${HOME}/.vim/plugged"
  pushd "${HOME}/.vim/plugged"
    git clone "https://github.com/junegunn/fzf"
    git clone "https://github.com/junegunn/fzf.vim"
    git clone "https://github.com/tpope/vim-surround"
    git clone "https://github.com/tpope/vim-repeat"
    git clone "https://github.com/tpope/vim-commentary"
    git clone "https://github.com/SirVer/ultisnips"
    git clone "https://github.com/honza/vim-snippets"
    git clone "https://github.com/majutsushi/tagbar"
    git clone "https://github.com/ludovicchabant/vim-gutentags"
    git clone "https://github.com/mcchrish/nnn.vim"
    git clone "https://github.com/prettier/vim-prettier"
    git clone "https://github.com/neoclide/coc.nvim"
    git clone "https://github.com/tpope/vim-fugitive"

    git clone "https://github.com/ryanoasis/vim-devicons"
    git clone "https://github.com/sheerun/vim-polyglot"
    git clone "https://github.com/morhetz/gruvbox"
  popd
fi

# Oh-my-zsh
if [ ! -f "${HOME}/.oh-my-zsh" ]; then
  chsh -s /bin/zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# dotfiles
if [ ! -f "$HOME/dotfiles" ]; then
  echo "==> Setting up dotfiles"
  cd "$HOME"
  git clone --recursive https://github.com/panda622/dotfiles.git
fi

# Link files
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
rm -rf ~/.vimrc
rm -rf ~/.zshrc
rm -rf ~/.gitconfig
rm -rf ~/.ctags
rm -rf ~/.tmux.conf
rm -rf ~/.config/nvim
ln -sfn ~/dotfiles/.vimrc "${HOME}/.config/nvim/init.vim"
ln -sfn ~/dotfiles/UltiSnips "${HOME}/.config/nvim/UltiSnips"
ln -sfn ~/dotfiles/.zshrc "${HOME}/.zshrc"
ln -sfn ~/dotfiles/.tmux.conf "${HOME}/.tmux.conf"
ln -sfn ~/dotfiles/.gitconfig "${HOME}/.gitconfig"
ln -sfn ~/dotfiles/.ctags "${HOME}/.ctags"

echo 'tren-may' > /etc/hostname
