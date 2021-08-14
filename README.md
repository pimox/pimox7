Pixmox - Proxmox for the Raspberry Pi
===

Pimox is a port of Proxmox to the Raspberry Pi allowing you to build a Proxmox cluster of Rapberry Pi's or even a hybrid cluster of Pis and x86 hardware.

Requirements
---
* Raspberry Pi 4
* Pre-installed Debian based 64-bit OS ___(not 32-bit)___

Prechecks
---
1. In /etc/network/interfaces, give the Pi a static IP address. You cannot use dhcp.
2. In /etc/network/interfaces, remove any IPv6 addresses.
3. In /etc/hostname, make sure the Pi has a name.
4. In /etc/hosts, make sure this hostname corresponds to the static IP you previous set.

Install
---
1. Do this at the console, not over a network. The network will be reconfigured as part of the install.
2. sudo -s
3. curl https://gitlab.com/pimox/pimox7/-/raw/master/pimox.sh | sh

Notes
---
1. This repo just contains the precompiled debian packages. The original Proxmox sources can be found at git.proxmox.com
2. The (very minimally) patched sources to rebuild this can be found at github.com/pimox

