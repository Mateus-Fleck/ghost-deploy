#!/bin/bash
# ============================================================
# Runs ON the Oracle Ubuntu 22.04 (ARM) VM to deploy Ghost.
# Prereqs: this ghost-deploy/ folder (with a filled-in .env) has been
# copied to the VM, e.g. via scp. Run from inside the folder:
#   bash deploy-oracle.sh
# ============================================================
set -e
cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "ERROR: .env not found. Copy .env.oracle.example to .env and fill it in."
  exit 1
fi

echo "=== [1/4] Installing Docker (if missing) ==="
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER" || true
  echo "Docker installed."
else
  echo "Docker already present."
fi

echo "=== [2/4] Docker versions ==="
sudo docker --version
sudo docker compose version

echo "=== [3/4] Build + start Ghost (this pulls the ARM ghost:6-alpine base) ==="
sudo docker compose up -d --build

echo "=== [4/4] Status ==="
sudo docker compose ps
echo ""
echo "Tail logs with:  sudo docker compose logs -f ghost"
echo "Ghost should be reachable on port 80 at the VM public IP."
echo "Admin setup:     http://<PUBLIC_IP>/ghost"
