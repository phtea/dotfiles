#!/usr/bin/env bash
set -euo pipefail

SESSION="tasks"

### === Настраиваемые цвета и оформление ===
COLOR_ICON="#[fg=#888888]"
COLOR_ACTIVE="#[fg=#DDDDDD]"
COLOR_INACTIVE="#[fg=#888888]"
COLOR_RESET="#[default]"
ICON=""
LABEL="Tasks:"
SEP=" "     # разделитель между названиями
### ========================================

# Если сессии нет — молчим
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  exit 0
fi

# Проверяем, attached ли текущий клиент к сессии tasks
CURRENT_SESSION=$(tmux display-message -p '#S')
if [[ "$CURRENT_SESSION" == "$SESSION" ]]; then
  exit 0  # Не выводим ничего, если мы уже в сессии tasks
fi

# Формат строки для tmux list-windows.
FMT="#{?window_active,${COLOR_ACTIVE},${COLOR_INACTIVE}}#{window_name}${COLOR_RESET}"

# Собираем окна
windows="$(tmux list-windows -t "$SESSION" -F "$FMT")"

# Склеиваем в одну строку с разделителем
line="$(printf '%s\n' "$windows" | paste -sd"$SEP" - | sed 's/  \+/ /g')"

# Заголовок + список
printf '%s%s %s %s%s\n' "$COLOR_ICON" "$ICON" "$LABEL" "$line" "$COLOR_RESET"
