#!/bin/bash
set -e

PARTITION="/dev/sda1"
MOUNTPOINT="/mnt/data"
FSTAB="/etc/fstab"

echo "=== Omarchy NVMe Auto-Setup ==="

# Detect and install ntfs-3g using available package manager
install_ntfs3g() {
    if command -v pacman >/dev/null 2>&1; then
        echo "[*] Installing ntfs-3g with pacman..."
        sudo pacman -Sy --noconfirm ntfs-3g

    elif command -v xbps-install >/dev/null 2>&1; then
        echo "[*] Installing ntfs-3g with xbps..."
        sudo xbps-install -Sy ntfs-3g

    elif command -v dnf >/dev/null 2>&1; then
        echo "[*] Installing ntfs-3g with dnf..."
        sudo dnf install -y ntfs-3g

    elif command -v emerge >/dev/null 2>&1; then
        echo "[*] Installing ntfs-3g with emerge (Gentoo)..."
        sudo emerge sys-fs/ntfs3g

    else
        echo "[ERROR] Could not detect a supported package manager."
        echo "Install ntfs-3g manually and rerun this script."
        exit 1
    fi
}

# 1. Install ntfs-3g if missing
if ! command -v ntfs-3g >/dev/null 2>&1; then
    install_ntfs3g
else
    echo "[OK] ntfs-3g already installed."
fi

# 2. Create mount point if missing
if [ ! -d "$MOUNTPOINT" ]; then
    echo "[*] Creating mount directory at $MOUNTPOINT..."
    sudo mkdir -p "$MOUNTPOINT"
else
    echo "[OK] Mount directory exists."
fi

# 3. Get the UUID
echo "[*] Getting UUID for $PARTITION..."
UUID=$(blkid -s UUID -o value "$PARTITION")

if [ -z "$UUID" ]; then
    echo "[ERROR] Could not get UUID for $PARTITION"
    exit 1
fi

echo "[OK] Found UUID: $UUID"

# 4. Add fstab entry if it doesn't exist
FSTAB_ENTRY="UUID=$UUID  $MOUNTPOINT  ntfs-3g  defaults,windows_names,locale=en_US.utf8  0  0"

if grep -q "$UUID" "$FSTAB"; then
    echo "[OK] fstab entry already exists."
else
    echo "[*] Adding entry to /etc/fstab..."
    echo "$FSTAB_ENTRY" | sudo tee -a "$FSTAB" >/dev/null
fi

# 5. Mount everything
echo "[*] Mounting..."
sudo mount -a

echo
echo "=== Setup Complete ==="
echo "Your NTFS drive is now mounted at: $MOUNTPOINT"
echo "It will auto-mount on each boot."

