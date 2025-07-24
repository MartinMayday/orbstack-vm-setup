#!/bin/bash

# VM install script: Adds pasted pubkey
echo "Paste your macmax pubkey (from clipboard) and press Enter:"
read PUBKEY

if [ -z "$PUBKEY" ]; then
  echo "Error: No pubkey provided!"
  exit 1
fi

AUTHORIZED_FILE="/mnt/data/ssh/authorized_keys"

echo "Adding pubkey to $AUTHORIZED_FILE..."
if [ ! -d "/mnt/data/ssh" ]; then
  echo "Warning: /mnt/data/ssh not found. Trying to create..."
  sudo mkdir -p /mnt/data/ssh || { echo "Error: Cannot create dir—check mounts/permissions!"; exit 1; }
  sudo chmod 700 /mnt/data/ssh
  sudo chown $(whoami):$(whoami) /mnt/data/ssh
fi

if ! sudo grep -q "$PUBKEY" "$AUTHORIZED_FILE"; then
  echo "$PUBKEY" | sudo tee -a "$AUTHORIZED_FILE" > /dev/null || { echo "Error: Cannot write to file!"; exit 1; }
  sudo chmod 600 "$AUTHORIZED_FILE"
  echo "Key added!"
else
  echo "Key already exists."
fi

# Restart SSH if possible
if command -v systemctl >/dev/null; then
  sudo systemctl restart ssh || echo "Warning: SSH restart failed."
elif command -v service >/dev/null; then
  sudo service ssh restart || echo "Warning: SSH restart failed."
else
  echo "Warning: Cannot restart SSH—do manually."
fi

# Get IP
echo "VM's current IP:"
if command -v ip >/dev/null; then
  ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1
elif command -v ifconfig >/dev/null; then
  ifconfig | grep -oP 'inet\s+\K\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1
else
  echo "Error: No IP tool found—check manually."
fi

echo "Done! Return to macmax for integration."
