# Export
export ZSH="${HOME}/.oh-my-zsh"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh

# Setting
HISTFILE=~/.zhistory
SAVEHIST=10000

# PS1
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Alias
alias ..="cd .."
alias gt="ctags -f .vscode/tags -R ."
alias wm="vim ~/dotfiles/i3.conf"
alias ws='cd ~/dotfiles'
alias co='cd ~/code'
alias v='nvim'
alias sv='sudo nvim'
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

alias ll='ls -l --color=auto'
