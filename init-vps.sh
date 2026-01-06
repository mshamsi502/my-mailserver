#!/bin/bash

# ==============================================================================
# Script Name: init-vps.sh
# Description: Automated system preparation for Delta Chat Server.
# Features: Auto-detects hostname and configures environment.
# ==============================================================================

# Auto-detect current hostname
CURRENT_HOSTNAME=$(hostname)

echo "[LOG] Step 1: Terminating conflicting update processes..."
sudo systemctl stop unattended-upgrades
sudo killall -9 apt apt-get 2>/dev/null

echo "[LOG] Step 2: Removing package manager locks..."
sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock

echo "[LOG] Step 3: Repairing interrupted installations..."
sudo dpkg --configure -a

echo "[LOG] Step 4: Configuring hostname resolution for '$CURRENT_HOSTNAME'..."
# Ensures the system can resolve its own name to avoid 'unable to resolve host' errors
if ! grep -q "127.0.0.1 $CURRENT_HOSTNAME" /etc/hosts; then
    echo "127.0.0.1 $CURRENT_HOSTNAME" | sudo tee -a /etc/hosts
fi

echo "[LOG] Step 5: Installing Docker and Docker-Compose..."
sudo apt update
sudo apt install docker.io docker-compose -y

echo "[LOG] Step 6: Configuring Firewall (UFW) for Mail Services..."
sudo apt install ufw -y
sudo ufw allow 22/tcp    # SSH Access
sudo ufw allow 25/tcp    # SMTP Server-to-Server
sudo ufw allow 587/tcp   # SMTP Client Submission
sudo ufw allow 143/tcp   # IMAP Standard
sudo ufw allow 993/tcp   # IMAP SSL
sudo ufw allow 465/tcp   # SMTP SSL
sudo ufw allow 80/tcp    # HTTP for Let's Encrypt
sudo ufw --force enable

echo "[LOG] Step 7: Verifying active ports..."
sudo netstat -tulpen | grep -E '25|143|587|993'

echo "[SUCCESS] VPS initialization for '$CURRENT_HOSTNAME' completed."