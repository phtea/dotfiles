#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Wallpaper setter and colorscheme
cat ~/.cache/wal/sequences
wallset() {
	wal -i "$1"
	feh --bg-fill "$1"
}

# My aliases
alias c='clear'
alias brc='vim ~/.bashrc'
alias sbrc='source ~/.bashrc'
alias act='. venv/bin/activate'
alias deact='deactivate'
alias py='python'
export EDITOR=/usr/bin/vim
export GTK_FILE_CHOOSER=dmenu
export MOZ_GTK_FILE_CHOOSER=fff

eval "$(starship init bash)"
