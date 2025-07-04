# History settings
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=10000
export HISTSIZE=1000
export LESS='-R' LESSHISTFILE=-
shopt -s histappend

# Completion settings
bind "set completion-ignore-case on"
[ -f /etc/bash_completion ] && source /etc/bash_completion

# History-driven history (up/down arrows)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Editor configuration
export EDITOR=$(command -v nvim >/dev/null && echo nvim || echo vim) VISUAL=$EDITOR

# Useful Aliases
alias reload='source ~/.bashrc' brc='$EDITOR ~/.bashrc' grep='grep --color=auto'
alias gc="git commit" gp="git push" gl="git log" gs="git status --short" ga="git add" gu="git pull"

# Enable color support for ls and grep
command -v dircolors &>/dev/null && eval "$(dircolors -b)" && alias ls='ls --color=auto'

# Add to PATH only if directory exists
[ -d "$HOME/bin" ] && export PATH="$PATH:$HOME/bin"
[ -d "/usr/local/bin" ] && export PATH="$PATH:/usr/local/bin"
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"
[ -d "/opt/nvim-linux-x86_64/bin" ] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# FZF keybindings
[ -e /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Git branch prompt
parse_git_branch() { git symbolic-ref --short HEAD 2>/dev/null | sed 's/^/ /'; }

# PS1 prompt with colors
GREEN='\[\033[01;32m\]' BLUE='\[\033[01;34m\]' RED='\[\033[31m\]' RESET='\[\033[00m\]'
export PS1="${GREEN}\u ${BLUE}\w${RESET}${RED}\$(parse_git_branch)${RESET} $ "

# Add scripts here
[ -f "$HOME/.bash/custom_functions" ] && source "$HOME/.bash/custom_functions"
