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
go install github.com/fomiller/assume-role@latest

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

# install doppler
echo "======> Downloading and installing dopper"
apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | tee /etc/apt/sources.list.d/doppler-cli.list
apt-get update && apt-get install doppler

