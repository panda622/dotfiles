# ===================
#    EXPORT
# ===================
export VISUAL=nvim
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fpath+=("$HOME/.zsh/pure")

# ===================
#    PROMPT
# ===================
autoload -U promptinit; promptinit
prompt pure

# ===================
#    ALIAS
# ===================
alias ..="cd .."

alias gfa="git fetch --all"
alias gst="git status"
alias gco="git checkout $1"
alias gcb="git checkout -b $1"
alias gaa="git add ."
alias glg="git log --oneline"
alias gcm="git checkout master"
alias ggpush="git push origin master"
alias ggpull="git pull origin master"
alias gcmsg="git commit -m $1"
alias gc!="git commit --amend"
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias glod="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

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

alias rc="rails console"
alias rs="rails server"
alias rdc="bundle exec rake db:create"
alias rdd="bundle exec rake db:drop"
alias rdm="bundle exec rake db:migrate"
alias rds="bundle exec rake db:seed"
alias rdr="bundle exec rake db:rollback"
alias rr="bundle exec rake routes"
alias rgm="rails g migration"
alias rgcc="rails g controller"
alias rgmm="rails g model"

alias portlisten="sudo lsof -i -P -n | grep LISTEN"
alias myip="ifconfig | grep -w inet"
alias wm="vim ~/dotfiles/i3.conf"

# ===================
#    HISTORY
# ===================

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# ===================
#    PLUGINS
# ===================

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# ===================
#    KEY BINDINGS
# ===================

bindkey '^P' up-history
bindkey '^N' down-history

bindkey '^E' autosuggest-accept

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
