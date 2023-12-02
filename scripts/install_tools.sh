#!/bin/bash

TF_VERSION=1.3.9
TG_VERSION=0.48.5

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
echo "======> Downloading and installing doppler"
apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | tee /etc/apt/sources.list.d/doppler-cli.list
apt-get update && apt-get install doppler

# install kubectl
echo "======> Downloading and installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "======> Downloading and installing kubectl convert"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl-convert"
echo "$(cat kubectl-convert.sha256) kubectl-convert" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert
kubectl convert --help
rm kubectl-convert kubectl-convert.sha256
