#!/usr/bin/env bash

# install utility dependecies
echo "======> Downloading and installing utilities"
apt-get update && apt-get upgrade
apt-get install -y wget
apt-get install -y curl
apt-get install -y unzip && apt-get install -y zip

# install python3.9
echo "======> Downloading and installing python"
apt-get update && apt-get install -y software-properties-common gcc && add-apt-repository -y ppa:deadsnakes/ppa
apt-get update && apt-get install -y python3.9 python3-distutils python3-pip python3-apt
apt-get install python-is-python3

# install golang
echo "======> Downloading and installing python"
wget https://golang.org/dl/go1.18.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz

# install terraform
echo "======> Downloading and installing tfswitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
echo "======> Installing terraform 1.1.6"
tfswitch 1.1.6
echo "======> Downloading and installing tgswitch"
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
echo "======> Installing terragrunt 0.36.1"
tgswitch 0.36.1


# install aws
echo "======> Downloading and installing aws cli"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

#install please.build
echo "======> Downloading and installing please.build"
curl https://get.please.build > please.sh
sh ./please.sh
source ~/.profile
echo 'source <(plz --completion_script)' > ~/.bashrc
rm -f please.sh
plz --version
