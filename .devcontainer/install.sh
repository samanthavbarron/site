#!/bin/bash
set -e

### HUGO
HUGO_VERSION=$(curl -fsSL https://api.github.com/repos/gohugoio/hugo/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": "v\(.*\)".*/\1/')
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  HUGO_ARCH="amd64" ;;
    aarch64) HUGO_ARCH="arm64" ;;
    *)       HUGO_ARCH="$ARCH" ;;
esac
TMP_DIR=$(mktemp -d)
curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${HUGO_ARCH}.tar.gz" \
    | tar -xz -C "$TMP_DIR" hugo
sudo install -m 0755 "$TMP_DIR/hugo" /usr/local/bin/hugo
rm -rf "$TMP_DIR"

# Claude Code
curl -fsSL https://claude.ai/install.sh | bash

### DOCKER
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
# Install
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin tmux