#!/bin/bash
set -e

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

# curl -fsSL https://get.docker.com | $SUDO sh
# 
# 
# COMPOSE_VERSION=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
# $SUDO mkdir -p /usr/local/lib/docker/cli-plugins
# curl -fsSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-$(uname -m)" \
#     | $SUDO tee /usr/local/lib/docker/cli-plugins/docker-compose >/dev/null
# $SUDO chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
# 
# $SUDO service docker start


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
$SUDO install -m 0755 "$TMP_DIR/hugo" /usr/local/bin/hugo
rm -rf "$TMP_DIR"
