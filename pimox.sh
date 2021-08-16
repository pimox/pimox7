#! /bin/sh

curl https://raw.githubusercontent.com/pimox/pimox7/master/KEY.gpg | apt-key add -
echo "deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/" > /etc/apt/sources.list.d/pimox.list
echo "deb http://deb.debian.org/debian bullseye contrib" > /etc/apt/sources.list.d/buster-contrib.list
apt update
apt install -y proxmox-ve
