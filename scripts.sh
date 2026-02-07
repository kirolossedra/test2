#!/usr/bin/env bash
set -euo pipefail

PREFIX="${HOME}/.local"
JOBS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)"

echo "[*] Installing tmux into: ${PREFIX}"
mkdir -p "${PREFIX}"

# If tmux repo already exists, update it; else clone it.
if [ -d "${HOME}/tmux/.git" ]; then
  echo "[*] tmux repo already exists, updating..."
  cd "${HOME}/tmux"
  git fetch --all --tags
  git reset --hard origin/master || true
else
  echo "[*] Cloning tmux..."
  cd "${HOME}"
  git clone https://github.com/tmux/tmux.git
  cd tmux
fi

echo "[*] Building tmux from source..."
sh autogen.sh

# Try configure; if dependencies are missing, tell you exactly what to do.
if ! ./configure --prefix="${PREFIX}"; then
  echo
  echo "[!] Configure failed (missing build deps like libevent/ncurses headers)."
  echo "[!] On many Mininet VMs, 'screen' is already installed and works fine:"
  echo "    screen    (detach: Ctrl+a then d, reattach: screen -r)"
  echo
  exit 1
fi

make -j "${JOBS}"
make install

# Put tmux in PATH for future shells
if ! grep -q 'export PATH=$HOME/.local/bin:$PATH' "${HOME}/.bashrc" 2>/dev/null; then
  echo 'export PATH=$HOME/.local/bin:$PATH' >> "${HOME}/.bashrc"
fi

export PATH="${HOME}/.local/bin:${PATH}"

echo "[✓] Installed:"
"${PREFIX}/bin/tmux" -V
echo "[*] Open a new terminal or run: source ~/.bashrc"
