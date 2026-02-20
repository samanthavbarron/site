#!/bin/bash
set -e

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

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
