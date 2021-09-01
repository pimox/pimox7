#! /bin/sh

apt install -y gnupg
curl https://raw.githubusercontent.com/pimox/pimox7/master/KEY.gpg | apt-key add -
echo "deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/" > /etc/apt/sources.list.d/pimox.list
apt update
apt install -y proxmox-ve
