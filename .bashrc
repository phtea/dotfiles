# History settings
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Completion settings
bind "set completion-ignore-case on"

# Useful Aliases
alias ll='ls -alF' la='ls -A' l='ls -CF' grep='grep --color=auto' reload='source ~/.bashrc'

# Enable color support for ls and grep if available
[ -x "$(command -v dircolors)" ] && eval "$(dircolors -b)" && alias ls='ls --color=auto'

# PATH setup
export PATH="$HOME/bin:/usr/local/bin:$HOME/go/bin:$(npm config get prefix)/bin:$HOME/.local/bin:$PATH"

# Editor configuration
export EDITOR=nvim VISUAL=$EDITOR
alias v=$EDITOR vi=$EDITOR

# Git branch prompt
parse_git_branch() { git branch 2>/dev/null | grep '^*' | colrm 1 2 | sed 's/^/ /'; }

# PS1 prompt with colors
GREEN='\[\033[01;32m\]' BLUE='\[\033[01;34m\]' RED='\[\033[31m\]' RESET='\[\033[00m\]'
export PS1="${GREEN}\u ${BLUE}\w${RESET}${RED}\$(parse_git_branch)${RESET} $ "

# File viewing settings
export LESS='-R' LESSHISTFILE=-
