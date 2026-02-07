#!/usr/bin/env bash
set -e

echo "[*] Backing up sources.list"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "[*] Switching Ubuntu repos to old-releases (EOL fix)"
sudo sed -i \
  's|http://archive.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g; \
   s|http://security.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' \
  /etc/apt/sources.list

echo "[*] Updating apt (ignore Valid-Until)"
sudo apt-get update -o Acquire::Check-Valid-Until=false

echo "[*] Installing tmux"
sudo apt-get install -y tmux

echo "[✓] Done"
tmux -V
