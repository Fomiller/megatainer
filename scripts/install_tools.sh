#!/bin/bash

OS=`uname`
if [ "$OS" = "Linux" ]; then
    GOOS="linux"
elif [ "$OS" = "Darwin" ]; then
    GOOS="darwin"
elif [ "$OS" = "FreeBSD" ]; then
    GOOS="freebsd"
else
    echo "Unknown operating system $OS"
    exit 1
fi

ARCH=`uname -m`
if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64"] || [ "${ARCH}" = "aarch64" ]; then
    ARCH="arm64"
else
    echo "Unsupported cpu arch $ARCH"
    exit 1
fi
echo "Running on ${ARCH}"

echo "======> Installing Go programs"
go install github.com/Fomiller/assume-role@latest

echo "======> Installing Cargo programs"
cargo install just 

# install terraform
echo "======> Downloading and installing tfswitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
echo "======> Installing terraform 1.1.6"
tfswitch 1.1.6

# install terragrunt
echo "======> Downloading and installing tgswitch"
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
echo "======> Installing terragrunt 0.42.8"
tgswitch 0.42.8
