#!/bin/bash

# VM install script: Adds pasted pubkey to ~/.ssh/authorized_keys
echo "Paste your macmax pubkey (from clipboard) and press Enter:"
read PUBKEY

if [ -z "$PUBKEY" ]; then
  echo "Error: No pubkey provided!"
  exit 1
fi

AUTHORIZED_FILE="$HOME/.ssh/authorized_keys"

echo "Adding pubkey to $AUTHORIZED_FILE..."
mkdir -p ~/.ssh || { echo "Error: Cannot create ~/.ssh!"; exit 1; }
chmod 700 ~/.ssh

if ! grep -q "$PUBKEY" "$AUTHORIZED_FILE"; then
  echo "$PUBKEY" >> "$AUTHORIZED_FILE" || { echo "Error: Cannot write to file!"; exit 1; }
  chmod 600 "$AUTHORIZED_FILE"
  echo "Key added!"
else
  echo "Key already exists."
fi

# Restart SSH
sudo systemctl restart ssh || sudo service ssh restart || echo "Warning: Cannot restart SSH—do manually."

# Get IP
echo "VM's current IP:"
ip addr show | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | grep -v "127.0.0.1" | head -1 || ifconfig | grep -oP "inet\s+\K\d+(\.\d+){3}" | grep -v "127.0.0.1" | head -1 || echo "Error: No IP tool—check manually."

echo "Done! Return to macmax."
