#!/bin/bash
MONITOR_1="HDMI-A-1"  # Change this to match your monitor name
MONITOR_2="HDMI-A-2"

CURRENT=$(hyprctl monitors | awk -v mon="$MONITOR_1" '
    $2 == mon {getline; print $1}' )

if [[ "$CURRENT" == 2560x1440* ]]; then
    echo "Switching to mac-friendly resolution (1600x900@144)..."
    hyprctl keyword monitor "$MONITOR_1,1600x900@144,auto,2"
    hyprctl keyword monitor "$MONITOR_2,1600x900@144,auto,2"
elif [[ "$CURRENT" == 1600x900* ]]; then
    echo "Switching back to Default (2560x1440@144)..."
    hyprctl keyword monitor "$MONITOR_1,preferred,auto,1"
    hyprctl keyword monitor "$MONITOR_2,preferred,auto,1"
else
    echo "Current mode is $CURRENT — defaulting to Default."
    hyprctl keyword monitor "$MONITOR_1,preferred,auto,1"
    hyprctl keyword monitor "$MONITOR_2,preferred,auto,1"
fi
