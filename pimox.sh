#! /bin/sh

curl http://gitlab.home/pimox/pimox7/-/raw/master/KEY.gpg | apt-key add -
echo "deb http://gitlab.home/pimox/pimox7/-/raw/master/ dev/" > /etc/apt/sources.list.d/pimox.list
echo "deb http://deb.debian.org/debian bullseye contrib" > /etc/apt/sources.list.d/buster-contrib.list
apt update
apt install -y proxmox-ve
