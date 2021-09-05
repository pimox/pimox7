#!/bin/bash
#################################################################
# Name:        RPiOS64fullautoinst.sh     Version:      0.0.1   #
# Created:     05.09.2021                 Modified: 05.09.2021  #
# Author:      Joachim Traeuble                                 #
# Purpose:     fully automated pimox7 installaton on a RPi4 B   #
#################################################################
# 
# This script is ment to be to run as root.
#
# Don't forget to set your root password! --> sudo -u root passwd
# Else you won't be able to logon to the Web GUI.
#
# Tested with image from:
# https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2021-05-28/2021-05-07-raspios-buster-arm64-lite.zip
#
#### !!! PROPPERLY CONFIGURE THESE SETTINGS !!! #########
HOSTNAM="RPi4-PVE-Test"         # new hostname          #
RPI4_IP="192.168.178.250"       # new static ip         #
GATEWAY="192.168.178.1"         # your gateway          #
NETMASK="/24"                   # = 255.255.255.0       #
#########################################################

sudo apt update && sudo apt upgrade -y
sudo apt install -y gnupg curl #zram #nmon #screen ##if wanted

sudo rm /etc/apt/sources.list.d/*.list
sudo rm /etc/apt/sources.list

sudo printf "# Raspberry Pi OS Bullseye Repo
deb http://archive.raspberrypi.org/debian/ bullseye main
# Pimox7 Development Repo
deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/
# Debian Bullseye Reop
deb http://deb.debian.org/debian bullseye main contrib
# Debian Bullseye Security Updates
deb http://security.debian.org/debian-security bullseye-security main contrib non-free\n" > /etc/apt/sources.list

curl https://raw.githubusercontent.com/pimox/pimox7/master/KEY.gpg | sudo apt-key add -

sudo echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections #### How to reset at end?
sudo DEBIAN_FRONTEND=noninteractive apt update && sudo apt -y -o Dpkg::Options::="--force-confold" dist-upgrade 
sudo apt install -y raspberrypi-kernel-headers

sudo rm /etc/network/interfaces

sudo printf "auto eth0
iface eth0 inet static
address $RPI4_IP$NETMASK
gateway $GATEWAY\n" > /etc/network/interfaces

sudo hostnamectl set-hostname $HOSTNAM

sudo rm /etc/hosts

sudo printf "$RPI4_IP\t$HOSTNAM
127.0.0.1\tlocalhost\n" > /etc/hosts

sudo apt purge -y dhcpcd5 #dphys-swapfile #if remove wanted
sudo apt autoremove -y

sudo DEBIAN_FRONTEND=noninteractive apt install -y -o Dpkg::Options::="--force-confdef" proxmox-ve
sudo systemctl reboot
