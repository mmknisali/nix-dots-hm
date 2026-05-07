#!/usr/bin/env zsh
# Main zsh configuration file

# Load completions
autoload -Uz compinit
compinit

# Load custom configurations from conf.d
conf_dir="${ZDOTDIR:-$HOME/.config/zsh}/conf.d"
if [ -d "$conf_dir" ]; then
  for file in "$conf_dir"/*.zsh(.N); do
    source "$file"
  done
fi

# Load functions
fpath=("${ZDOTDIR:-$HOME/.config/zsh}/functions" $fpath)
autoload -Uz $fpath[1]/*(.:t)

# HyDE integration - load HyDE zsh configs if they exist
if [ -f "${ZDOTDIR:-$HOME/.config/zsh}/plugin.zsh" ]; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/plugin.zsh"
fi

if [ -f "${ZDOTDIR:-$HOME/.config/zsh}/user.zsh" ]; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/user.zsh"
fi

# Editor
export EDITOR=nvim
export VISUAL=nvim

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups

# Key bindings
bindkey -e
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff | bat'
alias gb='git branch'
alias gco='git checkout'
alias gcl='git clone'
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias gst='git stash'
alias gstp='git stash pop'
alias cat='bat'
alias op='opencode'
alias opc='opencode --continue'
alias gstl='git stash list'

# PATH additions
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.opencode/bin:$PATH
export PATH=$PATH:$HOME/.spicetify

# Homebrew (if installed)
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv zsh)"
elif [ -d "$HOME/.linuxbrew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv zsh)"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# Run freshfetch on startup
if command -v freshfetch >/dev/null 2>&1; then
  freshfetch
fi
