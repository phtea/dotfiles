# History settings
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=10000
export HISTSIZE=1000
shopt -s histappend
export LESS='-R' LESSHISTFILE=-

# Completion settings
command -v bind &>/dev/null && bind "set completion-ignore-case on"

# Editor configuration
export EDITOR=nvim VISUAL=$EDITOR
alias nv=$EDITOR

# Useful Aliases
alias ll='ls -alF' la='ls -A' l='ls -CF' grep='grep --color=auto'
alias reload='source ~/.bashrc' brc='$EDITOR ~/.bashrc'

# Git aliases
command -v git &>/dev/null && {
  alias gc="git commit" gp="git push" gl="git pull" gs="git status"
  alias ga="git add . && git status"
}

# Enable color support for ls and grep
command -v dircolors &>/dev/null && eval "$(dircolors -b)" && alias ls='ls --color=auto'

# PATH setup
export PATH="$PATH:$HOME/bin:/usr/local/bin:$HOME/.local/bin"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"

# FZF keybindings
[ -e /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# File watcher function
ondo() {
  [ $# -ne 2 ] && echo "Usage: ondo <file-pattern> <command>" && return 1
  command -v entr &>/dev/null || { echo "Warning: 'entr' is required but not installed."; return 1; }
  find . -name "$1" | entr -r sh -c "$2"
}

# Git branch prompt
parse_git_branch() { command -v git &>/dev/null && git branch 2>/dev/null | grep '^*' | colrm 1 2 | sed 's/^/ /'; }

# PS1 prompt with colors
GREEN='\[\033[01;32m\]' BLUE='\[\033[01;34m\]' RED='\[\033[31m\]' RESET='\[\033[00m\]'
export PS1="${GREEN}\u ${BLUE}\w${RESET}${RED}\$(parse_git_branch)${RESET} $ "

# Load Cargo environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
