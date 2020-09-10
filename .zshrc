# Export
export ZSH=$HOME/.oh-my-zsh
export EDITOR="nvim"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export NVM_DIR="$HOME/.nvm"
export PATH="$HOME/myscript:${PATH}"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.gem/ruby/2.7.0/bin:${PATH}"

# Config
ZSH_THEME="steeef"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
source ~/dotfiles/alias.sh

# Application
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
