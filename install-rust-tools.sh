#!/bin/bash
set -euo pipefail

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

# -------------------------------------------------------
# Install Rust tools via system packages
# -------------------------------------------------------
echo -e "${GREEN}Installing rust-analyzer and rust-src...${NC}"
yay -S --noconfirm --needed rust-analyzer rust-src


# -------------------------------------------------------
# Ensure ~/.cargo/bin in PATH
# -------------------------------------------------------
if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
    echo -e "${YELLOW}~/.cargo/bin not in PATH. Adding it to ~/.bashrc...${NC}"
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
fi


echo -e "${GREEN}All done!${NC}"
