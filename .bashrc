# History settings
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTCONTROL=ignoredups:erasedups # Ignore duplicates and remove duplicates from history
export HISTFILESIZE=10000               # Size of the history file
export HISTSIZE=1000                    # Number of commands to store in memory
shopt -s histappend                     # Append to history instead of overwriting
export LESS='-R' LESSHISTFILE=-

# Completion settings
bind "set completion-ignore-case on"

# Useful Aliases
alias ll='ls -alF' la='ls -A' l='ls -CF' grep='grep --color=auto' reload='source ~/.bashrc'

# Git aliases
alias gc="git commit" gp="git push" gl="git pull" gs="git status" ga="git add . && git status"

# Enable color support for ls and grep if available
[ -x "$(command -v dircolors)" ] && eval "$(dircolors -b)" && alias ls='ls --color=auto'

# PATH setup
export PATH="$PATH:$HOME/bin:/usr/local/bin:$HOME/.local/bin:"
export PATH="$PATH:$HOME/go/bin" # Go

# Editor configuration
export EDITOR=nvim VISUAL=$EDITOR
alias nv=$EDITOR

# FZF keybindings
[ -e /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Convenient function to use entr with a file pattern and command
ondo() {
  if [ $# -ne 2 ]; then
    echo "Usage: ondo <file-pattern> <command>"
    return 1
  fi

  local file_pattern="$1"
  local command="$2"

  # Check if entr is installed
  if ! command -v entr &> /dev/null; then
    echo "entr is required, but it's not installed."
    return 1
  fi

  # Use entr to watch for file changes and execute the command
  find . -name "$file_pattern" | entr -r sh -c "$command"
}

# Git branch prompt
parse_git_branch() { git branch 2>/dev/null | grep '^*' | colrm 1 2 | sed 's/^/ /'; }

# PS1 prompt with colors
GREEN='\[\033[01;32m\]' BLUE='\[\033[01;34m\]' RED='\[\033[31m\]' RESET='\[\033[00m\]'
export PS1="${GREEN}\u ${BLUE}\w${RESET}${RED}\$(parse_git_branch)${RESET} $ "
