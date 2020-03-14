# Export
export ZSH="/home/dev1/.oh-my-zsh"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Theme
ZSH_THEME="simple"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Alias
alias ..="cd .."
alias wm="vim ~/dotfiles/i3.conf"
alias ws='cd ~/dotfiles'
alias co='cd ~/code'
alias v='nvim'
alias vim='nvim'
alias vimrc='nvim ~/dotfiles/vimrc'
alias zshrc='nvim ~/dotfiles/zshrc'
alias tmc="nvim ~/dotfiles/tmux.conf"

alias tml="tmux list-sessions"
alias tmn="tmux -2 -u new -s $1"
alias tma="tmux -2 -u attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmd="tmux kill-server"

alias dcc="docker container"
alias di="docker images"
alias dc="docker-compose"
