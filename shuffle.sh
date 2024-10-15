#!/bin/bash

# Check if script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update and upgrade system packages
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install curl ssh net-tools ca-certificates -y

# Create directory for apt keyrings
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Ensure correct permissions for the key
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt and install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Clone the Shuffle repository
git clone https://github.com/Shuffle/Shuffle

# Navigate to the Shuffle directory
cd Shuffle

# Create necessary directories
mkdir shuffle-database

# Ensure ownership of the database directory
sudo chown -R 1000:1000 shuffle-database

# Disable swap
sudo swapoff -a

# Bring up the Docker Compose environment
docker compose up -d

# Credentials:
# admin@admin.local
# admin

