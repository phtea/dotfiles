#!/bin/bash

# Kill any running polybar instances
killall -q polybar

# Wait for them to fully shut down
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.1; done

# Launch the bar (change "top" to your bar name)
polybar top &
