# !/bin/bash
#################################################################
# Name:        RPiOS64fullautoinst.sh     Version:      0.1.0   #
# Created:     07.09.2021                 Modified: 23.09.2021  #
# Author:      TuxfeatMac J.T.                                  #
# Purpose:     full automated Pimox7 installation RPi4B, RPi3B+ #
#################################################################
# Tested with image from:                                       #
# https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2021-05-28/
#################################################################

#### SET SOME COLOURS ###########################################
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
GREY=$(tput setaf 8)

#### SCRIPT IS MENT TO BE TO RUN AS ROOT! NOT AS PI WITH SUDO ###
if [ $USER != root ]
 then
  printf "This script is ment to be to run as superuser!\n"
  exit
fi

#### GET THE RPI MODEL #### EXTRA STEPS FOR RPI3B+ ##############
RPIMOD=$(cat /sys/firmware/devicetree/base/model | cut -d ' ' -f 3)
if [ $RPIMOD == 3 ]
 then
  printf "Edit installer.sh manually.. I hope you know what you are doing..."
  exit
  ## WORKS BUT DOSEN'T SHOW RPI 3 WARNINGS YET ...
  # [ ] ADD WARNING MESSAGES
  # [ ] GET RPI3 VALUES SWAP ZRAM INSTED OF HAND EDETING
  PI3_ZRAM='1664'                 # zram 1,6GB
  PI3_SWAP='384'                  # dphys-swapfile 0,4GB
  ##
  apt install -y zram-tools
  printf "SIZE=$PI3_ZRAM\nPRIORITY=100\nALGO=lz4\n" >> /etc/default/zramswap
  printf "CONF_SWAPSIZE=$PI3_SWAP\n" >> /etc/dphys-swapfile
  vm.swappiness=100 >> /etc/sysctl.d/99-sysctl.conf
  # fix net names eth0 | enxMAC # !
  RPIMAC=$(ip a | grep ether | cut -d ' ' -f 6)
  printf "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$RPIMAC\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"eth0\"\n" > /etc/udev/rules.d/70-presistant-net.rules
fi

#### GET USER INPUTS #### HOSTNAME ##############################
read -p "Enter new hostname e.g. RPi4-01-PVE : " HOSTNAME
while [[ ! "$HOSTNAME" =~ ^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$  ]]
 do
  printf " --->$RED $HOSTNAME $NORMAL<--- Is NOT an valid HOSTNAME, try again...\n"
  read -p "Enter new hostname e.g.: RPi4-01-PVE  : " HOSTNAME
done

#### IP AND NETMASK ! ###########################################
read -p "Enter new static IP and NETMASK e.g. 192.168.0.100/24 : " RPI_IP
while [[ ! "$RPI_IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}+\/[0-9]+$ ]]
 do
  printf " --->$RED $RPI_IP $NORMAL<--- Is NOT an valid IPv4 ADDRESS with NETMASK, try again...\n"
  read -p "IPADDRESS & NETMASK ! E.G.: 192.168.0.100/24 : " RPI_IP
done
RPI_IP_ONLY=$(echo "$RPI_IP" | cut -d '/' -f 1)

#### GATEWAY ####################################################
GATEWAY="$(echo $RPI_IP | cut -d '.' -f 1,2,3).1"
read -p"Is $GATEWAY the correct gateway ?  y / n : " CORRECT
if [ "$CORRECT" != "y" ]
 then
  read -p "Enter the gateway  e.g. 192.168.0.1 : " GATEWAY
  while [[ ! "$GATEWAY" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$  ]]
   do
    printf " --->$RED $GATEWAY $NORMAL<--- Is NOT an valid IPv4 GATEWAY, try again...\n"
    read -p "THE GATEWAY IP ! E.G. 192.168.0.1 : " GATEWAY
  done
fi

#### AGREE TO OVERRIDES #########################################
printf "
$YELLOW#########################################################################################
=========================================================================================$NORMAL
THE NEW HOSTNAME WILL BE:$GREEN $HOSTNAME $NORMAL
=========================================================================================
THE DHCP SERVER ($YELLOW dhcpcd5 $NORMAL) WILL BE $RED REMOVED $NORMAL !!!
=========================================================================================
ALL FILES IN: $YELLOW /etc/apt/sources.list.d/$RED* $NORMAL WILL BE $RED DELETED $NORMAL !!!
=========================================================================================
ALL EXISTING REPOSITORIES IN : $YELLOW /etc/apt/sources.list $NORMAL WILL BE $RED OVERWRITTEN $NORMAL !!! WITH :

$GRAY# Raspberry Pi OS 11 Bullseye Repo$NORMAL
deb http://archive.raspberrypi.org/debian/ bullseye main
$GRAY# Pimox 7 Development Repo$NORMAL
deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/
$GRAY# Debian 11 Bullseye Repo$NORMAL
deb http://deb.debian.org/debian bullseye main contrib
$GRAY# Debian 11 Bullseye Security Updates Repo$NORMAL
deb http://security.debian.org/debian-security bullseye-security main contrib

=========================================================================================
THE NETWORK CONFIGURATION IN : $YELLOW /etc/network/interfaces $NORMAL WILL BE $RED OVERWRITTEN $NORMAL !!! WITH :

auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address $GREEN$RPI_IP$NORMAL
gateway $GREEN$GATEWAY$NORMAL

=========================================================================================
THE HOSTNAMES IN : $YELLOW /etc/hosts $NORMAL WILL BE $RED OVERWRITTEN $NORMAL !!! WITH :
127.0.0.1\tlocalhost
$RPI_IP_ONLY\t$HOSTNAME

=========================================================================================
THESE STATEMENTS WILL BE $RED ADDED $NORMAL TO THE $YELLOW /boot/cmdline.txt $NORMAL IF NONE EXISTENT :

cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

$YELLOW=========================================================================================
#########################################################################################$NORMAL

"

#### PROMPT FOR CONFORMATION ####################################
read -p "YOU ARE OKAY WITH THESE CHANGES ? YOUR DECLARATIONS ARE CORRECT ? CONTINUE ? y / n : " CONFIRM
if [ "$CONFIRM" != "y" ]; then exit; fi

#### SET A ROOT PWD FOR WEB GUI LOGIN ##### #####################
printf "
==========================
! SET YOUR ROOT PASSWORD !
==========================
" && passwd
if [ $? != 0 ]; then exit; fi

#### BASE UPDATE, DEPENDENCIES INSTALLATION #####################
apt update && apt upgrade -y    # maybe upgrade could be skiped ?
apt install -y gnupg            # nmon #screen

#### ADDJUST SOURCES 11 | PIMOX7 + KEY #############################
rm -f /etc/apt/sources.list.d/*.list
printf "# Raspberry Pi OS 11 Bullseye Repo
deb http://archive.raspberrypi.org/debian/ bullseye main
# PiMox 7 Development Repo
deb https://raw.githubusercontent.com/pimox/pimox7/master/ dev/
# Debian 11 Bullseye Repo
deb http://deb.debian.org/debian bullseye main contrib
# Debian 11 Bullseye Security Updates Repo
deb http://security.debian.org/debian-security bullseye-security main contrib \n" > /etc/apt/sources.list
curl https://raw.githubusercontent.com/pimox/pimox7/master/KEY.gpg |  apt-key add -

#### UPDATE UND UPGRADE TO 11 ######################################
echo '* libraries/restart-without-asking boolean true' |  debconf-set-selections #### How to reset at end?
DEBIAN_FRONTEND=noninteractive apt update &&  apt -y -o Dpkg::Options::="--force-confold" dist-upgrade
apt install -y raspberrypi-kernel-headers

#### RECONFIGURE NETWORK ########################################
printf "auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address $RPI_IP
gateway $GATEWAY\n" > /etc/network/interfaces

#### SET NEW HOSTNAME ###########################################
hostnamectl set-hostname $HOSTNAME
printf "127.0.0.1\tlocalhost
$RPI_IP_ONLY\t$HOSTNAME" > /etc/hosts

#### REMOVE DHCP, CLEAN UP #########################################
apt purge -y dhcpcd5
apt autoremove -y

# FIX CONTAINER STATS NOT SHOWING UP IN WEB GUI ####################
if [ "$(cat /boot/cmdline.txt | grep cgroup)" != "" ]
 then
  printf "Seems to be already fixed!"
 else
  sed -i "1 s|$| cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1|" /boot/cmdline.txt
fi

# INSTALL PIMOX7 AND REBOOT#########################################
DEBIAN_FRONTEND=noninteractive apt install -y -o Dpkg::Options::="--force-confdef" proxmox-ve
printf "
=========================================
! ERRORS ARE NOMALAY FINE -> README.md  !
=========================================
\n" && sleep 3
printf "
=========================================
! INSTALATION COMPLETED ! WAIT ! REBOOT !
=========================================
\n" && sleep 7 && reboot

#### EOF ####
