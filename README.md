Pixmox - Proxmox for the Raspberry Pi
===

Pimox is a port of Proxmox to the Raspberry Pi allowing you to build a Proxmox cluster of Rapberry Pi's or even a hybrid cluster of Pis and x86 hardware.

Requirements
---
* Raspberry Pi 4
* Pre-installed Debian based 64-bit OS ___(not 32-bit)___

Prechecks
---
1. Give the Pi a fixed IP address in /etc/network/interfaces. You cannot use dhcp.
2. Remove any IPv6 addresses in /etc/network/interfaces.

Install
---
1. sudo -s
2. curl https://gitlab.com/pimox/pimox7/-/raw/master/pimox.sh | sh

Notes
---
1. This repo just contains the precompiled debian packages. The original Proxmox sources can be found at git.proxmox.com
2. The (very minimally) patched sources to rebuild this can be found at github.com/pimox

