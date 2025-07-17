# History settings
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=10000
export HISTSIZE=1000
export LESS='-R' LESSHISTFILE=-
shopt -s histappend

# ---------------------------------------------------
# Bash completion (Arch + Ubuntu universal)
# ---------------------------------------------------
bind "set completion-ignore-case on"

if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# ---------------------------------------------------
# FZF completion + keybindings (universal)
# ---------------------------------------------------
# Completion
if [ -f /usr/share/fzf/completion.bash ]; then
  source /usr/share/fzf/completion.bash
elif [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  source /usr/share/doc/fzf/examples/completion.bash
fi

# Keybindings
if [ -f /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# History-driven history (up/down arrows)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Editor configuration
export EDITOR=$(command -v nvim >/dev/null && echo nvim || echo vim)
VISUAL=$EDITOR

# Useful Aliases
alias reload='source ~/.bashrc' brc='$EDITOR ~/.bashrc' grep='grep --color=auto'
alias gc="git commit" gp="git push" gl="git log" gs="git status --short" ga="git add" gu="git pull" gd="git diff"

# t === tmux-here - create a tmux session based on directory name
alias t="tmux-here"
tmux-here() {
  local session_name="${PWD##*/}"
  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach -t "$session_name"
  else
    tmux new-session -s "$session_name"
  fi
}

# OP: Do a command on file update
ondo() {
  if [ $# -ne 2 ]; then
    echo "Usage: ondo <file-pattern> <command>"
    return 1
  fi

  local file_pattern="$1"
  local command="$2"

  if ! command -v entr &> /dev/null; then
    echo "entr is required, but it's not installed."
    return 1
  fi

  # Use entr to watch for file changes and execute the command
  find . -name "$file_pattern" | entr -r sh -c '
    clear
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $ '"$command"'"
    '"$command"'
  '
}

# Enable color support for ls and grep
command -v dircolors &>/dev/null && eval "$(dircolors -b)" && alias ls='ls --color=auto'

# Add to PATH only if directory exists
[ -d "$HOME/bin" ] && export PATH="$PATH:$HOME/bin"
[ -d "/usr/local/bin" ] && export PATH="$PATH:/usr/local/bin"
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"
[ -d "/opt/nvim-linux-x86_64/bin" ] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
[ -d "/opt/helix" ] && export PATH="$PATH:/opt/helix"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"
[ -d "$HOME/scripts" ] && export PATH="$PATH:$HOME/scripts"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Git branch prompt
parse_git_branch() { git symbolic-ref --short HEAD 2>/dev/null | sed 's/^/ /'; }

# PS1 prompt with colors
GREEN='\[\033[01;32m\]' BLUE='\[\033[01;34m\]' RED='\[\033[31m\]' RESET='\[\033[00m\]'
export PS1="${GREEN}\u ${BLUE}\w${RESET}${RED}\$(parse_git_branch)${RESET} $ "

# Add scripts here
[ -f "$HOME/.bash/custom_functions" ] && source "$HOME/.bash/custom_functions"
