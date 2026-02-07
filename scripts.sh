#!/usr/bin/env bash
set -e

echo "[*] Backing up sources.list"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "[*] Switching Ubuntu repos to old-releases (EOL fix)"
sudo sed -i "s|archive.ubuntu.com|old-releases.ubuntu.com|g; s|security.ubuntu.com|old-releases.ubuntu.com|g" /etc/apt/sources.list

echo "[*] Disabling valid-until + insecure repo checks"
sudo apt-get update \
  -o Acquire::Check-Valid-Until=false \
  -o Acquire::AllowInsecureRepositories=true \
  -o Acquire::AllowDowngradeToInsecureRepositories=true

echo "[*] Installing tmux (allow unauthenticated)"
sudo apt-get install -y tmux --allow-unauthenticated

echo "[✓] Done"
tmux -V
