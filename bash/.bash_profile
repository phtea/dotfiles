# ~/.bash_profile
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
