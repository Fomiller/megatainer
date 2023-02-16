#!/usr/bin/env bash

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

# install utility dependecies
# echo "======> Downloading and installing utilities"
apt-get update && apt-get upgrade
apt-get install -y wget
apt-get install -y curl
apt-get install -y git
apt-get install -y unzip && apt-get install -y zip

# # install python3.9
echo "======> Downloading and installing python"
apt-get update && apt-get install -y software-properties-common gcc && add-apt-repository -y ppa:deadsnakes/ppa
apt-get update && apt-get install -y python3.9 python3-distutils python3-pip python3-apt
apt-get install python-is-python3

# # install golang
echo "======> Downloading and installing golang"
wget https://golang.org/dl/go1.18.linux-${ARCH}.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-${ARCH}.tar.gz
# 
# # install cargo/rust
echo "======> Downloading and installing rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# install terraform
echo "======> Downloading and installing tfswitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
echo "======> Installing terraform 1.1.6"
tfswitch 1.1.6

# install terragrunt
echo "======> Downloading and installing tgswitch"
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
echo "======> Installing terragrunt 0.36.1"
tgswitch 0.36.1

echo "======> Downloading and installing just"
cargo install just 

# # install aws
# echo "======> Downloading and installing aws cli"
# if [ "$ARCH" = "amd64"]; then
#   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#   unzip awscliv2.zip
#   sh ./aws/install
# else
#   curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
#   unzip awscliv2.zip
#   sh ./aws/install
# fi

# #install please.build
# echo "======> Downloading and installing please.build"
# please install script does not work on arm64, but i think it is still possible to install
# please is not compatible with aarch64 architecture even though arm64 and aarch64 are the same
# curl https://get.please.build > please.sh
# ls
# sh ./please.sh
# source ~/.profile
# echo 'source <(plz --completion_script)' > ~/.bashrc
# rm -f please.sh
# plz --version
