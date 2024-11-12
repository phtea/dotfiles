# Set history settings for better usability
HISTSIZE=10000               # Number of commands to remember in history
HISTFILESIZE=20000           # Max lines in the history file
HISTCONTROL=ignoredups       # Ignore duplicate entries
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help" # Ignore trivial commands
shopt -s histappend          # Append to the history file, don’t overwrite it
shopt -s cmdhist             # Store multi-line commands as single entry
bind "set completion-ignore-case on" # Enable case-insensitive completion

# Enhanced command prompt
PS1='\[\e[1;32m\]\u@\h \[\e[1;34m\]\w\[\e[0m\] $ '

# Useful Aliases
alias ll='ls -alF'           # Long listing with file type indicators
alias la='ls -A'             # List all files except . and ..
alias l='ls -CF'             # Compact list view
alias ..='cd ..'             # Go up one directory
alias ...='cd ../..'         # Go up two directories
alias grep='grep --color=auto'  # Colorize grep output
alias cls='clear'            # Clear the terminal screen
alias h='history'            # Quickly view command history
alias gs='git status'        # Git status shortcut
alias gp='git pull'          # Git pull shortcut
alias gc='git commit'        # Git commit shortcut

# Enable color support for ls and grep if available
if [ -x "$(command -v dircolors)" ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Set PATH for common programming tools (modify as needed)
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Editor configuration (set your preferred editor)
export EDITOR=nvim            # Set default editor to Vim
export VISUAL=$EDITOR

# Enable auto-completion features if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Custom Functions
# Git log with a simplified graph and colored output
git_log() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}
alias gl='git_log'           # Shortcut for git log function

# Reload .bashrc
alias reload='source ~/.bashrc'

# Custom prompt command to show current git branch if in a git repository
parse_git_branch() {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}
export PS1="\[\033[01;32m\]\u@\h \[\033[01;34m\]\w\[\033[00m\]\[\033[31m\]\$(parse_git_branch)\[\033[00m\] $ "

# User-specific environment and startup programs
export PATH="$HOME/.local/bin:$PATH"

# Better 'cd' command with path suggestions
shopt -s cdspell          # Correct minor spelling errors in directory names
shopt -s autocd           # Allow directory names to be used without 'cd'

# Configure less for easier file viewing
export LESS='-R'          # Enable raw control characters
export LESSHISTFILE=-     # Disable less history file

# Vim-related enhancements
alias v=$EDITOR              # Shortcut to open Vim easily
alias vi=$EDITOR             # Alias vi to vim
alias vimdiff="$EDITOR -d"   # Use vimdiff for comparing files
