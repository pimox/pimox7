# !/bin/bash
#################################################################
# Name:        Automation_Custom_Script.sh	Version:0.0.1   #
# Created:     26.09.2021                 Modified: 26.09.2021  #
# Author:      TuxfeatMac J.T.                                  #
# Purpose:     full automated Pimox7 installation RPi4B         #
#################################################################
# Tested with image from:                                       #
# https://dietpi.com/downloads/images/DietPi_RPi-ARMv8-Bullseye.7z
#################################################################

#-----------------------------------------------------------------------------------------------------#
#---- CONFIGURE-OPTIONS ------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------------#
GET_STD_IMG='yes/no'	# (default) no 	  | Debian & Ubuntu ARM64 TEMPLATEs & ISOs | ! DLSIZE ~ 2,0GB #		
CONFIG_ZRAM='yes/no'	# (default) no	  | install zram for swap ?	|			      #
       ZRAM='1664'	# (default) 1,6GB |				| 			      #
CONFIG_SWAP='yes/no'	# (default) no    | install dphys-swapfile ?	|			      #
       SWAP='384'	# (default) 0,4GB | 				| combined 2,0GB swap	      #
#-----------------------------------------------------------------------------------------------------#
#---- END-CONFIGURE-OPTIONS - ! NO TOUCHI BELOW THIS LINE ! - UNLESS YOU KNOW WHAT YOU ARE DOING -----#
#-----------------------------------------------------------------------------------------------------#

#### GET IP HOSTNAME NETAMSK AND GATEWAY FROM dietpi.txt ####
RPI_IP_ONLY=$(cat /boot/dietpi.txt | grep AUTO_SETUP_NET_STATIC_IP | cut -d '=' -f 2)
   HOSTNAME=$(cat /boot/dietpi.txt | grep AUTO_SETUP_NET_HOSTNAME | cut -d '=' -f 2)
    NETMASK=$(cat /boot/dietpi.txt | grep AUTO_SETUP_NET_STATIC_MASK | cut -d '=' -f 2)
    GATEWAY=$(cat /boot/dietpi.txt | grep AUTO_SETUP_NET_STATIC_GATEWAY | cut -d '=' -f 2)

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
if [ "$(cat /boot/cmdline.txt | grep cgroup)" = "" ]
 then
  sed -i "1 s|$| cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1|" /boot/cmdline.txt
fi

#### INSTALL DEPENDENCIES #######
DEBIAN_FRONTEND=noninteractive apt install -y -o Dpkg::Options::="--force-confdef" screen raspberrypi-kernel-headers zfs-dkms
printf "# Pimox 7 Development Repo
deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/" > /etc/apt/sources.list.d/pimox7.list
curl https://raw.githubusercontent.com/pimox/pimox7/master/KEY.gpg |  apt-key add -
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

#### INSTALL Pimox7 ######
DEBIAN_FRONTEND=noninteractive screen -S pveinst apt install -y -o Dpkg::Options::="--force-confdef" proxmox-ve

#### DISABLE TIMESYNCED FOR NTP SINCE CHRONYD WILL BE USED BY PVE ####
sed -i 's/CONFIG_NTP_MODE=1/CONFIG_NTP_MODE=0/g' /boot/dietpi.txt

#### Get CT's VM's #### seperate script ?
if [ "$GET_STD_IMG" == "yes" ]
 then
  ARCHITEC=arm64
  cd /var/lib/vz/template/cache
  #### Debian 11 / Bullseye Arm 64 - CT
  DISTNAME=debian
  CODENAME=bullseye
  NEWESTBUILD=$(curl https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/ | grep '<td>' | tail -n 1 | cut -d '='  -f 5 | cut -d '/' -f 2)
  wget https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/$NEWESTBUILD/rootfs.tar.xz -O Debian11$ARCHITEC-std-$NEWESTBUILD.tar.xz
  #### Ubuntu 20.04 LTS Arm 64 - CT
  DISTNAME=ubuntu
  CODENAME=focal
  NEWESTBUILD=$(curl https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/ | grep '<td>' | tail -n 1 | cut -d '='  -f 5 | cut -d '/' -f 2)
  wget https://us.images.linuxcontainers.org/images/$DISTNAME/$CODENAME/$ARCHITEC/default/$NEWESTBUILD/rootfs.tar.xz -O Ubuntu20$ARCHITEC-std-$NEWESTBUILD.tar.xz

  cd /var/lib/vz/template/iso
  #### Debian 11 / Bullseye Arm 64 - ISO NET INSTALL
  wget https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-11.0.0-arm64-netinst.iso
  #### Ubuntu 20.04 LTS Arm 64 - ISO LIVE SERVER
  wget https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.3-live-server-arm64.iso
fi

reboot
