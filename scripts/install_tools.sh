#!/bin/bash

TF_VERSION=1.3.9
TG_VERSION=0.42.8

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

# echo "======> Installing Cargo programs"
# cargo install just 

# install terraform
echo "======> Downloading and installing tfswitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
echo "======> Installing terraform ${TF_VERSION}"
tfswitch ${TF_VERSION}

# install terragrunt
echo "======> Downloading and installing tgswitch"
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
echo "======> Installing terragrunt ${TG_VERSION}"
tgswitch ${TG_VERSION}
