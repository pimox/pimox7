# !/bin/bash
#################################################################
# Name:        Automation_Custom_Script.sh  Version:      0.0.1 #
# Created:     26.09.2021                  Modified: 26.09.2021 #
# Author:      TuxfeatMac J.T.                                  #
# Purpose:     full automated Pimox7 installation RPi4B         #
#################################################################
# Tested with image from:                                       #
# https://raspi.debian.net/verified/20210823_raspi_4_bullseye.img.xz
#################################################################
#-----------------------------------------------------------------------------------------------------#
#---- CONFIGURE-NETWORK-HOSTANME ---------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------#
RPI_IP_ONLY='192.168.178.222'
   HOSTNAME='VRPi4-PVE-Test'
    NETMASK='255.255.255.0'
    GATEWAY='192.168.178.1'
#-----------------------------------------------------------------------------------------------------#
#---- CONFIGURE-OPTIONS ------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------#
GET_STD_IMG='yes/no'    # (default) no    | Debian & Ubuntu ARM64 TEMPLATEs & ISOs | ! DLSIZE ~ 400MB
CONFIG_ZRAM='yes/no'    # (default) no    | install zram for swap ?     |
       ZRAM='1664'      # (default) 1,6GB |                             |
CONFIG_SWAP='yes/no'    # (default) no    | install dphys-swapfile ?    |      
       SWAP='384'       # (default) 0,4GB |                             | combined 2,0GB swap
#-----------------------------------------------------------------------------------------------------#
#---- END-CONFIGURE ---- ! NO TOUCHI BELOW THIS LINE ! ----- UNLESS YOU KNOW WHAT YOU ARE DOING ------#
#-----------------------------------------------------------------------------------------------------#

#### ZRAM SWAP INSTALL ####
if [ "$CONFIG_ZRAM" == "yes" ]
 then
  apt install zram-tools
  printf "SIZE=$ZRAM\nPRIORITY=100\nALGO=lz4\n" >> /etc/default/zramswap
  printf "vm.swappiness=100\n" >> /etc/sysctl.d/99-sysctl.conf
fi

#### DPHYS-SWAPFILE SWAP INSTALL ####
if [ "$CONFIG_SWAP" == "yes" ]
 then
  apt install dphys-swapfile
  printf "CONF_SWAPSIZE=$SWAP\n" >> /etc/dphys-swapfile
fi

# FIX CONTAINER STATS NOT SHOWING UP IN WEB GUI ####################
#if [ "$(cat /boot/firmware/cmdline.txt | grep cgroup)" = "" ]
# then
#  sed -i "1 s|$| cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1|" /boot/cmdline.txt
#fi

#### INSTALL DEPENDENCIES #######
apt update
apt install -y curl gnupg screen linux-headers-$(uname -r) locales # zfs-dkms #dang locales missing
printf "# Pimox 7 Development Repo
deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/" > /etc/apt/sources.list.d/pimox7.list
curl https://raw.githubusercontent.com/pimox/pimox7/master/KEY.gpg |  apt-key add - # re edit contrib maybe missing ? nop
apt update

#### SET NEW HOSTNAME ###########################################
hostnamectl set-hostname $HOSTNAME
printf "127.0.0.1\tlocalhost
$RPI_IP_ONLY\t$HOSTNAME" > /etc/hosts

#### RECONFIGURE NETWORK ########################################
printf "auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address $RPI_IP_ONLY
netmask $NETMASK
gateway $GATEWAY\n" > /etc/network/interfaces

### RESOLVECONF ? MAYBE ?

#### INSTALL Pimox7 ######
DEBIAN_FRONTEND=noninteractive screen apt install -y -o Dpkg::Options::="--force-confdef" proxmox-ve

#### Get CT's VM's #### seperate script ?
if [ "$GET_STD_IMG" == "yes" ]
 then
  ARCHITEC=arm64
  cd /var/lib/vz/template/cache
  #### Debian 11 / Bullseye Arm 64 - CT #### ~ 70MB
  DISTNAME=debian
  CODENAME=bullseye
  NEWESTBUILD=$(curl https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/ | grep '<td>' | tail -n 1 | cut -d '='  -f 5 | cut -d '/' -f 2)
  wget https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/$NEWESTBUILD/rootfs.tar.xz -O Debian11$ARCHITEC-std-$NEWESTBUILD.tar.xz

  #### Ubuntu 20.04 LTS Arm 64 - CT #### depcreased to big ... ### maybe read with advanced config option
  # DISTNAME=ubuntu
  # CODENAME=focal
  # NEWESTBUILD=$(curl https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/ | grep '<td>' | tail -n 1 | cut -d '='  -f 5 | cut -d '/' -f 2)
  # wget https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/$NEWESTBUILD/rootfs.tar.xz -O Ubuntu20$ARCHITEC-std-$NEWESTBUILD.tar.xz

  cd /var/lib/vz/template/iso
  #### Debian 11 / Bullseye Arm 64 - ISO NET INSTALL #### ~ 320MB
  wget https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-11.0.0-arm64-netinst.iso
  #### Ubuntu 20.04 LTS Arm 64 - ISO LIVE SERVER
  # wget https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.3-live-server-arm64.iso
fi

reboot

