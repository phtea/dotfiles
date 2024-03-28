bindkey -e
# Emulate Bash key bindings
bindkey '^[[1;5C' forward-word  # Ctrl+Right - move right by one word
bindkey '^[[1;5D' backward-word # Ctrl+Left - move left by one word
bindkey '^[[3;5~' kill-word     # Ctrl+Delete - delete word after cursor
bindkey '^H' backward-delete-word # Ctrl+Backspace - delete word before cursor
bindkey '^[[H' beginning-of-line # Home - move cursor to start of line
bindkey '^[[F' end-of-line       # End - move cursor to end of line
