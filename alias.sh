alias ws='cd ~/dotfiles'
alias co='cd ~/code'
alias v='nvim'
alias sv='sudo nvim'
alias vim='nvim'
alias vimrc='nvim ~/dotfiles/.vimrc'
alias zshrc='nvim ~/dotfiles/.zshrc'
alias bashrc='nvim ~/.bashrc'
alias tmc="nvim ~/dotfiles/.tmux.conf"

alias tml="tmux list-sessions"
alias tmn="tmux -2 -u new -s $1"
alias tma="tmux -2 -u attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmd="tmux kill-server"

alias dcc="docker container"
alias di="docker images"
alias dc="docker-compose"

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
alias activenet='sudo route add -net 10.91.9.0/24 gw 10.91.16.65 & sudo route add -net 172.29.0.0/16 gw 10.91.16.65 & sudo route add -net 192.168.0.0/16 gw 10.91.16.65'
