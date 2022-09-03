#!/bin/bash
set -eu
export DEBIAN_FRONTEND=noninteractive
UPGRADE_PACKAGES=$1

export HOME=/mnt/blockstorage/user

if [ "${UPGRADE_PACKAGES:-none}" == "initialize" ]; then

  sudo timedatectl set-timezone Asia/Ho_Chi_Minh
  # sudo dnf update -y

  # Mount Volume
  mkdir -p /mnt/blockstorage
  echo >> /etc/fstab
  echo /dev/sda               /mnt/blockstorage       ext4    defaults,noatime,nofail 0 0 >> /etc/fstab
  mount /mnt/blockstorage
  mkdir -p /mnt/blockstorage/user
  useradd -d /mnt/blockstorage/user -g wheel dev
fi

sudo dnf install -y \
  lsof \
  util-linux-user \
  readline-devel \
  mysql-devel \
  mariadb-server \
  postgresql-server \
  postgresql-contrib \
  postgresql-devel \
  gcc-c++ \
  git-core \
  curl \
  docker  \
  docker-compose  \
  git \
  jq \
  htop \
  mosh \
  man \
  python \
  python3 \
  python3-pip \
  the_silver_searcher \
  tmux \
  ctags \
  nnn \
  rclone \
  neovim \
  zsh \
  fail2ban \
  fzf \
  unzip \
  bzip2 \
  xclip

sudo yum groupinstall "Development Tools" -y

if ! [ -x "$(command -v lazygit)" ]; then
  sudo dnf copr enable atim/lazygit -y
  sudo dnf install -y lazygit
fi

if ! [ -x "$(command -v aws)" ]; then
   python3 -m pip install awscli
fi

if ! [ -x "$(command -v eb)" ]; then
   python3 -m pip install awsebcli
fi

## Rbenv
if [ ! -d "${HOME}/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git "${HOME}/.rbenv"
fi

if [ ! -d "${HOME}/.rbenv/plugins" ]; then
  git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build"
fi

## Nvm
if [ ! -d "${HOME}/.nvm" ]; then
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

if [ ! -d "${HOME}/dotfiles" ]; then
  rm -rf ~/.vimrc
  rm -rf ~/.zshrc
  rm -rf ~/.gitconfig
  rm -rf ~/.ctags
  rm -rf ~/.tmux.conf
  rm -rf ~/.config/nvim
  rm -rf ~/.agignore

  cd $HOME
  git clone --recursive https://github.com/panda622/dotfiles.git
  cd "${HOME}/dotfiles"
  git remote set-url origin git@github.com:panda622/dotfiles.git

  mkdir -p "${HOME}/.config/nvim"
  ln -sfn ~/dotfiles/.vimrc "${HOME}/.config/nvim/init.vim"
  ln -sfn ~/dotfiles/UltiSnips "${HOME}/.config/nvim/UltiSnips"
  ln -sfn ~/dotfiles/.zshrc "${HOME}/.zshrc"
  ln -sfn ~/dotfiles/.tmux.conf "${HOME}/.tmux.conf"
  ln -sfn ~/dotfiles/.gitconfig "${HOME}/.gitconfig"
  ln -sfn ~/dotfiles/.ctags "${HOME}/.ctags"
  ln -sfn ~/dotfiles/.agignore "${HOME}/.agignore"

  touch /etc/fail2ban/jail.d/sshd.local
  ln -sfn ~/dotfiles/bin/sshd.local /etc/fail2ban/jail.d/sshd.local
fi

echo "==> Setting shell to zsh..."
chsh -s /bin/zsh dev

# Copy sshkey
if [ ! -d "${HOME}/.ssh" ]; then
  mkdir -p "${HOME}/.ssh"
  cp /root/.ssh/authorized_keys "${HOME}/.ssh/"
fi
sudo chown -R dev:wheel /mnt/blockstorage

# Docker
if [ "${UPGRADE_PACKAGES:-none}" == "initialize" ]; then
  echo 'dev ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers

  sudo groupadd -f docker
  sudo usermod -aG docker dev
  sudo systemctl enable --now docker.service
  chcon -Rt svirt_sandbox_file_t /mnt/blockstorage/docker
  chcon -Rt svirt_sandbox_file_t /mnt/blockstorage/docker-data

  touch /etc/docker/daemon.json
  json='{"data-root": "/mnt/blockstorage/docker"}'
  echo "$json" > /etc/docker/daemon.json
  sudo systemctl restart docker

  touch /etc/fail2ban/jail.d/sshd.local
  ln -sfn ~/dotfiles/bin/sshd.local /etc/fail2ban/jail.d/sshd.local

  chpasswd <<<"dev:&"
  sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
  sed -i '/^PermitRootLogin[ \t]\+\w\+$/{ s//PermitRootLogin no/g; }' /etc/ssh/sshd_config

  sudo systemctl restart fail2ban.service
fi

echo "=> Done!"
