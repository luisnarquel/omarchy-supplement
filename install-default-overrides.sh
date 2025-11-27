#!/bin/bash

set -e

DEFAULT_CONFIG="$HOME/.config/uwsm/default"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERRIDES_CONFIG="$SCRIPT_DIR/default-overrides.conf"
SOURCE_LINE="source $OVERRIDES_CONFIG"

# Check if the default config exists
if [ ! -f "$DEFAULT_CONFIG" ]; then
    echo "Default config not found at $DEFAULT_CONFIG"
    exit 1
fi

# Check if overrides config exists
if [ ! -f "$OVERRIDES_CONFIG" ]; then
    echo "Overrides config not found at $OVERRIDES_CONFIG"
    exit 1
fi

# Check if source line already exists in the default config
if grep -Fxq "$SOURCE_LINE" "$DEFAULT_CONFIG"; then
    echo "Source line already exists in $DEFAULT_CONFIG"
else
    echo "Adding source line to $DEFAULT_CONFIG"
    echo "" >> "$DEFAULT_CONFIG"  # Adds a newline before appending (optional)
    echo "$SOURCE_LINE" >> "$DEFAULT_CONFIG"
    echo "Source line added successfully"
fi

echo "Default config overrides setup complete!"
