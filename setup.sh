#!/bin/bash
set -eu
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -q -y \
  git-core \
  zlib1g-dev \
  build-essential \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  libcurl4-openssl-dev \
  software-properties-common \
  libffi-dev \
  curl \
  docker.io \
  docker-compose  \
  git \
  jq \
  htop \
  mosh \
  man \
  python \
  python3 \
  python3-pip \
  silversearcher-ag \
  tmux \
  ctags \
  nnn \
  rclone \
  neovim \
  zsh \
  unzip \
  --no-install-recommends
  sudo rm -rf /var/lib/apt/lists/*

if ! [ -x "$(command -v lazygit)" ]; then
  sudo add-apt-repository ppa:lazygit-team/release
  sudo apt-get update
  sudo apt-get install -q -y lazygit
fi

if ! [ -x "$(command -v psql)" ]; then
  sudo apt-get update
  sudo apt install -q -y postgresql-11 libpq-dev
fi

if [ ! -d "${HOME}/.fzf" ]; then
  echo " ==> Installing fzf"
  git clone https://github.com/junegunn/fzf "${HOME}/.fzf"
  pushd "${HOME}/.fzf"
  git remote set-url origin git@github.com:junegunn/fzf.git
  ${HOME}/.fzf/install --bin --no-bash --no-zsh --no-fish
  popd
fi


# Docker
#sudo groupadd docker
#sudo usermod -aG docker $USER
#sudo systemctl enable docker.service

## Rbenv
if [ ! -d "${HOME}/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  exec $SHELL

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  exec $SHELL

  rbenv install 3.0.3
  rbenv global 3.0.3
  gem install bundler
  rbenv rehash
fi

if [ ! -d "${HOME}/.rbenv/plugins" ]; then
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  exec $SHELL

  rbenv install 3.0.3
  rbenv global 3.0.3
  gem install bundler
  rbenv rehash
fi

## Nvm
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

## Oh-my-zsh

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

echo "==> Setting shell to zsh..."
chsh -s /usr/bin/zsh

echo ""
echo "=> Done!"
