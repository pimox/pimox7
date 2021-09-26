# !/bin/bash
#################################################################
# Name:        RPiOS64fullautoinst.sh     Version:      0.0.2   #
# Created:     07.09.2021                 Modified: 10.09.2021  #
# Author:      TuxfeatMac J.T.                                  #
# Purpose:     full automated Pimox7 installation RPi4B, RPi3B+ #
#################################################################
# Tested with image from: https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2021-05-28/2021-05-07-raspios-buster-arm64-lite.zip
#################################################################
#### BASIC  SETTINGS !! PROPPERLY CONFIGURE THESE SETTINGS !! ###
HOSTNAME='RPiX-PVE-X'           # set the new hostname
  RPI_IP='XXX.XXX.XXX.XXX'      # set new static ip address
 GATEWAY='XXX.XXX.XXX.X'        # set the gateway
 NETMASK='/24'                  # set the netmask only / notation
#### ADVANCED SETTINGS ##########################################
PI3_ZRAM='1664'                 # zram 1,6GB
PI3_SWAP='384'                  # dphys-swapfile 0,4GB
CT_STATS='true'                 # fix cmdline.txt for GUI stats
#PI4_ZRAM='no install'
#PI4_SWAP='will be removed'
#################################################################
# ! NO TOUCHIE BELOW THIS LINE UNLEES U KNOW WHAT YOU ARE DOING !
#################################################################

#### SCRIPT IS MENT TO BE TO RUN AS ROOT! NOT AS PI WITH SUDO ###
if [ $USER != root ]
 then
  printf "This script is ment to be to run as superuser!\n"
  exit # correct it, if u know how to improve it.
fi

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
RPIMOD=$(cat /sys/firmware/devicetree/base/model | cut -d ' ' -f 3)
if [ $RPIMOD == 3 ]
 then

  apt install -y zram-tools
  printf "SIZE=$PI3_ZRAM\nPRIORITY=100\nALGO=lz4\n" >> /etc/default/zramswap
  printf "CONF_SWAPSIZE=$PI3_SWAP\n" >> /etc/dphys-swapfile
  vm.swappiness=100 >> /etc/sysctl.d/99-sysctl.conf
  # fix net names eth0 | enxMAC
  RPIMAC=$(ip a | grep ether | cut -d ' ' -f 6)
  printf "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$RPIMAC\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"eth0\"\n" > /etc/udev/rules.d/70-presistant-net.rules
fi

#### ADDJUST SOURCES 11 | PIMOX7 + KEY #############################
rm -f /etc/apt/sources.list.d/*.list
printf "# Raspberry Pi OS 11 Bullseye Repo
deb http://archive.raspberrypi.org/debian/ bullseye main
# Pimox 7 Development Repo | PVE 7
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

#### RECONFIGURE NETWORK ###########################################
printf "auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address $RPI_IP$NETMASK
gateway $GATEWAY\n" > /etc/network/interfaces

#### SET NEW HOSTNAME ##############################################
hostnamectl set-hostname $HOSTNAME
printf "127.0.0.1\t\tlocalhost\n$RPI_IP\t\t$HOSTNAME\n" > /etc/hosts

#### REMOVE DHCP, CLEAN UP #########################################
apt purge -y dhcpcd5
if [ $RPIMOD == 4 ]
 then
  # remove sdcard swapfile # ask for it ?
  apt purge -y dphys-swapfile
fi
 apt autoremove -y

# FIX CONTAINER STATS NOT SHOWING UP IN WEB GUI ####################
if [ "$CT_STATS" == "true" ]
 then
  if [ "$(cat /boot/cmdline.txt | grep cgroup)" != "" ]
   then
    printf "Seems to be already fixed!"
   else
    sed -i "1 s|$| cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1|" /boot/cmdline.txt
  fi
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
