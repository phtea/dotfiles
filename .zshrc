# Source all zsh configs
for config ($ZSH/*.zsh) source $config

# Apply pywal
cat /home/tea/.cache/wal/sequences

# History file
HISTSIZE=5000
HISTFILE=$ZSH/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Load completion system
autoload -U compinit && compinit

# Basic auto/tab complete:
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case insensitive completion
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # sudo pacman -S extra/zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # sudo pacman -S extra/zsh-autosuggestions
eval "$(starship init zsh)"
