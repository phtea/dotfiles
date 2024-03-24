#      __            _                      __
#     / /____  ____ ( )_____    ____  _____/ /_  __________
#    / __/ _ \/ __ `/// ___/   /_  / / ___/ __ \/ ___/ ___/
#   / /_/  __/ /_/ / (__  )   _ / /_(__  ) / / / /  / /__
#   \__/\___/\__,_/ /____/   (_)___/____/_/ /_/_/   \___/

# Load colors
autoload -U colors && colors

# Customize prompt
PROMPT='%B%F{cyan}%n%f%b %F{yellow}in %B%F{cyan}%~%f%b %B%F{green}%#%f%b '

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# History
HISTFILE=~/.zhistory
HISTSIZE=2000
bindkey "^R" history-incremental-search-backward
bindkey '^[[A' up-history
bindkey '^[[B' down-history


# Wallpaper setter and colorscheme
cat ~/.cache/wal/sequences
wallset() {
    wal -i "$1" --backend colorz
    feh --bg-fill "$1"
    xdotool key alt+F5
}

# My aliases
alias c='clear'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias zrc='vim ~/.zshrc'
alias sz='source ~/.zshrc'
alias act='source venv/bin/activate'
alias deact='deactivate'
alias py='python'
alias v='sudo vim'
alias ins='sudo pacman -S'
alias binds='v .config/sxhkd/sxhkdrc'
alias locate='sudo find / -name'
alias smci='sudo make clean install'
alias smcu='sudo make clean uninstall'
alias smi='sudo make install'
alias smu='sudo make uninstall'

# My exports
export EDITOR=/usr/bin/vim
export GTK_FILE_CHOOSER=dmenu
export MOZ_GTK_FILE_CHOOSER=fff

# My keybinds
bindkey  "^[[H" beginning-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5D" beginning-of-line
bindkey "^[[1;5C" end-of-line
bindkey "^[[27;6;86~" vi-yank-eol
bindkey "^[[3;5~" vi-kill-eol

### Plugins have to be sourced at the end!

# Enable syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###
