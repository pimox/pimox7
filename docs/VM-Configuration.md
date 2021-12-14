# Starting a VM
Video showing CT and VM configuration: [PiMox7 - RPi4 - arm64 CT & VM Basic Configuration](https://youtu.be/LGb7fB1wK4Q).

### For a VM using Web-UI:

1. Click 'Create VM' in upper right
#### Under 'General'
2. Set 'name'
#### Under 'OS'
3. 'Do not use any media' (will be added later)
#### Under 'System' 
4. BIOS: 'OVMF (UEFI)'
5. Add 'EFI Storage'
6. 'Format: raw'
7. 'Qemu Agent:' Yes
#### Under 'Disks'
8. 'Format: raw'
#### Under 'CPU'
9. 'Cores: 2'
10. 'Type: host'
#### Under 'Memory'
11. 'Memory (MiB): 1024' (can allocate more if your model has the capacity)
#### Under 'Confirm'
12. 'Finish'

### On newly created VM sidebar
#### Under 'Hardware'
13. 'Remove "CD/DVD Drive (ide2)"'
14. 'Add 'CD/DVD Drive', 'Bus/Device: SCSI, 2', Choose ISO'
#### Under 'Options'
15. 'Boot Order: scsi2, scsi0'

***Start VM***

Confirmed to be working using an ```aarch64/arm64``` ISO
