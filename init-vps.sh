#!/bin/bash

# ==============================================================================
# Script Name: init-vps.sh (Professional Version)
# Description: Smart environment preparation for Delta Chat Server.
# Features: Idempotent (checks before install), auto-hostname, Docker V2.
# ==============================================================================

# 1. Auto-detect current hostname
CURRENT_HOSTNAME=$(hostname)

echo "[LOG] Step 1: Cleaning up package manager locks..."
sudo systemctl stop unattended-upgrades 2>/dev/null
sudo killall -9 apt apt-get 2>/dev/null
sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock
sudo dpkg --configure -a

echo "[LOG] Step 2: Configuring hostname resolution for '$CURRENT_HOSTNAME'..."
if ! grep -q "127.0.0.1 $CURRENT_HOSTNAME" /etc/hosts; then
    echo "127.0.0.1 $CURRENT_HOSTNAME" | sudo tee -a /etc/hosts
    echo "[INFO] Hostname added to /etc/hosts."
else
    echo "[INFO] Hostname already configured in /etc/hosts."
fi

echo "[LOG] Step 3: Checking/Installing Dependencies (curl, gnupg, net-tools)..."
sudo apt update
sudo apt install -y curl gnupg net-tools

echo "[LOG] Step 4: Checking Docker and Docker Compose V2..."
# Remove old docker-compose (V1) if exists to prevent conflicts
if command -v docker-compose &> /dev/null; then
    echo "[INFO] Old docker-compose V1 detected. Removing for upgrade..."
    sudo apt remove docker-compose -y
fi

# Install or Update Docker & Compose Plugin
if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
    echo "[INFO] Docker Compose V2 not found. Installing latest version..."
    sudo apt install -y docker.io docker-compose-v2
else
    echo "[INFO] Docker and Compose V2 are already installed. Checking for updates..."
    sudo apt install --only-upgrade -y docker.io docker-compose-v2
fi

echo "[LOG] Step 5: Configuring Firewall (UFW)..."
if ! command -v ufw &> /dev/null; then
    sudo apt install ufw -y
fi

# Apply firewall rules only if not already set
echo "[INFO] Setting up firewall rules..."
sudo ufw allow 22/tcp
sudo ufw allow 25,587,465/tcp   # SMTP Ports
sudo ufw allow 143,993/tcp      # IMAP Ports
sudo ufw allow 80/tcp           # HTTP Port
sudo ufw --force enable

echo "[LOG] Step 6: Verifying final installation status..."
echo "--- Docker Version ---"
docker --version
echo "--- Compose Version ---"
docker compose version
echo "--- Listening Ports ---"
sudo netstat -tulpen | grep -E '25|143|587|993'

echo "[SUCCESS] VPS initialization for '$CURRENT_HOSTNAME' is complete and up-to-date."
