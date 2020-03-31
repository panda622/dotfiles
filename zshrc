# Export
export ZSH="${HOME}/.zsh"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh

# Setting
HISTFILE=~/.zhistory
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


# PS1
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Alias
alias ..="cd .."
alias gt="ctags -f .vscode/tags -R ."
alias wm="vim ~/dotfiles/i3.conf"
alias plb="vim ~/.config/polybar/config.ini"
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

alias gst="git status"
alias gaa="git add ."
alias gcmsg="git commit -m $1"
alias ggpush="git po"
alias ggpull="git pull origin master"
alias gc!="git commit --amend --no-edit"

case `uname` in
  Darwin)
    alias ls='ls -GpF' # Mac OSX specific
    alias ll='ls -alGpF' # Mac OSX specific
  ;;
  Linux)
    alias ll='ls -al'
    alias ls='ls --color=auto' 
  ;;
esac
alias plisten="sudo lsof -i -P -n | grep LISTEN"



# =============
#    PROMPT
# =============
# autoload -U colors && colors
# setopt promptsubst

# local ret_status="%(?:%{$fg_bold[green]%}$:%{$fg_bold[green]%}$)"
# PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# # Outputs current branch info in prompt format
# function git_prompt_info() {
#   local ref
#   if [[ "$(command git config --get customzsh.hide-status 2>/dev/null)" != "1" ]]; then
#     ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
#     ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
#     echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
#   fi
# }

# # Checks if working tree is dirty
# function parse_git_dirty() {
#   local STATUS=''
#   local FLAGS
#   FLAGS=('--porcelain')

#   if [[ "$(command git config --get customzsh.hide-dirty)" != "1" ]]; then
#     FLAGS+='--ignore-submodules=dirty'
#     STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
#   fi

#   if [[ -n $STATUS ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
#   else
#     echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#   fi
#}
