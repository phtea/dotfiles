#!/usr/bin/env bash

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
TIME=$(date +%Y-%m-%d-%H%M%S)

if [[ "$1" == "area" ]]; then
    FILE="$DIR/${TIME}_selection.png"
    scrot -s "$FILE"
    MODE="Selected area"
else
    FILE="$DIR/${TIME}_screenshot.png"
    scrot "$FILE"
    MODE="Fullscreen"
fi

# Копируем в буфер
xclip -selection clipboard -t image/png -i "$FILE"

# Показываем уведомление
notify-send "📸 Screenshot taken" "$MODE copied to clipboard"
