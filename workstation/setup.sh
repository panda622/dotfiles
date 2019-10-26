#!/bin/bash

set -eu

apt-get install -qq \
  git \
  ctags \
  jq \
  mosh \
  tmux \
  zsh \
  silversearcher-ag \
  neovim \
  unzip \
  --no-install-recommends \

rm -rf /var/lib/apt/lists/*

apt-get -y upgrade

# install 1password
if ! [ -x "$(command -v op)" ]; then
  export OP_VERSION="v0.5.6-003"
  curl -sS -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/${OP_VERSION}/op_linux_amd64_${OP_VERSION}.zip
  unzip 1password.zip op -d /usr/local/bin
  rm -f 1password.zip
fi

VIM_PLUG_FILE="/root/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  mkdir -p "${HOME}/.config/nvim/plugged"
  pushd "${HOME}/.config/nvim/plugged"
    git clone "https://github.com/tpope/vim-commentary"
    git clone "https://github.com/tpope/vim-fugitive"
    git clone "https://github.com/tpope/vim-repeat"
    git clone "https://github.com/tpope/vim-rails"
    git clone "https://github.com/tpope/vim-surround"
    git clone "https://github.com/tpope/vim-dispatch"

    git clone "https://github.com/thoughtbot/vim-rspec"
    git clone "https://github.com/sheerun/vim-polyglot"
    git clone "https://github.com/junegunn/fzf.vim"
    git clone "https://github.com/junegunn/vim-easy-align"
    git clone "https://github.com/rking/ag.vim"
    git clone "https://github.com/majutsushi/tagbar"
    git clone "https://github.com/scrooloose/nerdtree"

    git clone "https://github.com/morhetz/gruvbox.git"
  popd
fi

if [ ! -d "${HOME}/.fzf" ]; then
  echo " ==> Installing fzf"
  git clone https://github.com/junegunn/fzf "${HOME}/.fzf"
  pushd "${HOME}/.fzf"
  git remote set-url origin git@github.com:junegunn/fzf.git
  ${HOME}/.fzf/install --bin --64 --no-bash --no-zsh --no-fish
  popd
fi

if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"

  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

  echo "==> Setting shell to zsh..."
  chsh -s /usr/bin/zsh
fi

if [ ! -x "$(command -v docker)" ]; then
  echo "==> Installing Docker..."
  wget -O - 'https://get.docker.com/' | bash
  sudo usermod -a -G docker $USER
fi

if [ ! -x "$(command -v docker-compose)" ]; then
  echo "==> Installing Docker-compose..."
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

mkdir -p /root/code
if [ ! -d /root/dotfiles ]; then
  echo "==> Setting up dotfiles"
  cd "/root"
  git clone --recursive https://github.com/bada62/dotfiles.git

  cd "/root/dotfiles"
  git remote set-url origin git@github.com:bada62/dotfiles.git

  mkdir -p "/root/.config/nvim"
  ln -sfn $(pwd)/vimrc "${HOME}/.config/nvim/init.vim"
  ln -sfn $(pwd)/zshrc "${HOME}/.zshrc"
  ln -sfn $(pwd)/tmux.conf "${HOME}/.tmux.conf"
  ln -sfn $(pwd)/gitconfig "${HOME}/.gitconfig"
fi

if [ ! -f "/root/secrets/pull-secrets.sh" ]; then
  echo "==> Creating pull-secret.sh script"

cat > pull-secrets.sh <<'EOF'
#!/bin/bash
set -eu
echo "Authenticating with 1Password"

export OP_SESSION_my=$(op signin https://my.1password.com bbhn1362@protonmail.com --output=raw)

echo "Pulling secrets"

op get document 'ws_rsa' > ws_rsa
op get document 'ws_rsa.pub' > ws_rsa.pub

rm -f ~/.ssh/ws_rsa
rm -f ~/.ssh/ws_rsa.pub

ln -sfn $(pwd)/ws_rsa ~/.ssh/ws_rsa
ln -sfn $(pwd)/ws_rsa ~/.ssh/ws_rsa.pub

chmod 0600 ~/.ssh/ws_rsa
chmod 0600 ~/.ssh/ws_rsa.pub

eval `ssh-agent -s`
ssh-add ~/.ssh/ws_rsa

echo "Done!"
EOF

  mkdir -p /root/secrets
  chmod +x pull-secrets.sh
  mv pull-secrets.sh ~/secrets
fi

timedatectl set-timezone Asia/Ho_Chi_Minh

echo ""
echo "==> Done!"
