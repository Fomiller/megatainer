#!/bin/bash

TF_VERSION=latest
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

echo "======> Installing Rust programs"
cargo install rm-improved

# install terraform
echo "======> Downloading and installing tfswitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
echo "======> Installing terraform ${TF_VERSION}"
tfswitch -u
echo "======> System using $(terraform --version)"

# install terragrunt
echo "======> Downloading and installing tgswitch"
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
echo "======> Installing terragrunt ${TG_VERSION}"
tgswitch ${TG_VERSION}

echo "======> Downloading and installing doppler"
(curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh || wget -t 3 -qO- https://cli.doppler.com/install.sh) | bash
doppler --version

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

echo "======> Downloading and installing krew plugin manager"
KREW="krew-linux_${ARCH}" &&
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
tar zxvf "${KREW}.tar.gz" &&
./"${KREW}" install krew
