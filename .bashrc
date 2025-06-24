# History settings
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=10000
export HISTSIZE=1000
export LESS='-R' LESSHISTFILE=-
shopt -s histappend

# Completion settings
command -v bind &>/dev/null && bind "set completion-ignore-case on"
[ -f /etc/bash_completion ] && source /etc/bash_completion

# History-driven history (up/down arrows)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Editor configuration
export EDITOR=nvim VISUAL=$EDITOR
alias nv=$EDITOR

# Useful Aliases
alias ll='ls -alF' la='ls -A' l='ls -CF' grep='grep --color=auto'
alias reload='source ~/.bashrc' brc='vim ~/.bashrc' v='vim'
alias py='python3'

# Git aliases
command -v git &>/dev/null && {
  alias gc="git commit" gp="git push" gl="git log" gs="git status --short"
  alias ga="git add" gu="git pull"
}

# Enable color support for ls and grep
command -v dircolors &>/dev/null && eval "$(dircolors -b)" && alias ls='ls --color=auto'

# Add to PATH only if directory exists
[ -d "$HOME/bin" ] && export PATH="$PATH:$HOME/bin"
[ -d "/usr/local/bin" ] && export PATH="$PATH:/usr/local/bin"
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"
[ -d "/etc/opt/nvim/bin" ] && export PATH="$PATH:/etc/opt/nvim/bin"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"

# Rust (Cargo) env setup
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# FZF keybindings
[ -e /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Git branch prompt
parse_git_branch() { command -v git &>/dev/null && git branch 2>/dev/null | grep '^*' | colrm 1 2 | sed 's/^/ /'; }

# PS1 prompt with colors
GREEN='\[\033[01;32m\]' BLUE='\[\033[01;34m\]' RED='\[\033[31m\]' RESET='\[\033[00m\]'
export PS1="${GREEN}\u ${BLUE}\w${RESET}${RED}\$(parse_git_branch)${RESET} $ "

# Add scripts here
[ -f "$HOME/.bash/custom_functions" ] && source "$HOME/.bash/custom_functions"
echo "Have fun coding!"
