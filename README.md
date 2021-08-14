Pixmox - Proxmox for the Raspberry Pi
===

Pimox is a port of Proxmox to the Raspberry Pi allowing you to build a Proxmox cluster of Rapberry Pi's or even a hybrid cluster of Pis and x86 hardware.

Requirements
---
* Raspberry Pi 4
* Pre-installed Debian based 64-bit OS ___(not 32-bit)___

Setup
---
0. *Make sure you have set the hostname of the Pi in /etc/hostname, given it a static IP and put the hostname and IP address in /etc/hosts. If you don't do this then the install will fail!* Also, remove any IPv6 configuration for the network (it's probably auto and this upsets the installer).
1. sudo -s
2. curl https://gitlab.com/pimox/pimox7/-/raw/master/KEY.gpg | apt-key add -
3. curl https://gitlab.com/pimox/pimox7/-/raw/master/pimox.list > /etc/apt/sources.list.d/pimox.list
4. apt update
5. apt install proxmox-ve

Notes
---
1. This repo just contains the precompiled debian packages. The original Proxmox sources can be found at git.proxmox.com
2. The (very minimally) patched sources to rebuild this can be found at github.com/pimox

