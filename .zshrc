# Export
export ZSH="${HOME}/.zsh"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
export LC_CTYPE="en_US.UTF-8"
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
 export REVIEW_BASE="release/R2.8_June"

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export KEYTIMEOUT=1

# Setting
HISTFILE=~/.zsh_history
SAVEHIST=1000000
SAVEHIST=1000000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
# ignore duplication command history list
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# share command history data
setopt share_history

# Prompt
source ~/dotfiles/git-prompt.sh

# Alias
alias ..="cd .."
alias ws='cd ~/dotfiles'
alias co='cd ~/code'
alias v='nvim'
alias sv='sudo nvim'
alias vim='nvim'
alias vimrc='nvim ~/dotfiles/.vimrc'
alias zshrc='nvim ~/dotfiles/.zshrc'
alias tmc="nvim ~/dotfiles/.tmux.conf"

alias tml="tmux list-sessions"
alias tmn="tmux -2 -u new -s $1"
alias tma="tmux -2 -u attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmd="tmux kill-server"

alias dcc="docker container"
alias di="docker images"
alias dc="docker-compose"

alias gb="git branch"
alias gcb="git checkout -b $1"
alias glg="git log --oneline"
alias glol="git log --oneline --all --decorate --graph"
alias gco="git checkout $1"
alias gcom="git checkout master $1"
alias gst="git status"
alias gaa="git add ."
alias gcmsg="git commit -m $1"
alias ggpush="git po"
alias ggpull="git pull origin $REVIEW_BASE"
alias gc!="git commit --amend --no-edit"

alias portlisten="netstat -anp tcp | grep LISTEN"

case `uname` in
  Darwin)
    alias ls='ls -GpF' # Mac OSX specific
    alias ll='ls -alGpF' # Mac OSX specific
    ;;
  Linux)
    alias ll='ls -al'
    alias ls='ls --color=auto'
    alias sps="sudo pacman -S"
    alias up="sudo pacman -Syu"
    alias ys="yaourt -S"
    alias wm="vim ~/dotfiles/.config/i3/config"
    alias plb="vim ~/dotfiles/.config/polybar/config.ini"
    ;;
esac
alias plisten="sudo lsof -i -P -n | grep LISTEN"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


function edit_and_run() {
  BUFFER="fc"
  zle accept-line
}
zle -N edit_and_run
bindkey "^v" edit_and_run
