#!/usr/bin/env bash
curl https://get.please.build > please.sh
sh ./please.sh
source ~/.profile
echo 'source <(plz --completion_script)' > ~/.bashrc
rm -f please.sh
plz --version
