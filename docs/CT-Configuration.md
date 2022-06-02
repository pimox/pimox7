# Starting a CT
Video showing CT and VM configuration: [PiMox7 - RPi4 - arm64 CT & VM Basic Configuration](https://youtu.be/LGb7fB1wK4Q).

### Download CT Image
1. Follow the link below to download the CT image
   1. Access the following link in your browser.
   - https://uk.lxd.images.canonical.com/images/
   2. Dig deeper into the links, focusing on OS distributions and versions, and CPU architectures. And Select arm64 as the architecture.
   - For example, an Oracle Linux image file might look like this
   - https://uk.lxd.images.canonical.com/images/oracle/7/amd64/default/20220601_07:46/rootfs.tar.xz
   3. Rename and store the downloaded files in the LXC folder.
   - For example, the following can be executed with the CLI command
   - wget -O /var/lib/vz/template/cache/oracle-linux-7.tar.xz https://uk.lxd.images.canonical.com/images/oracle/7/amd64/default/20220601_07:46/rootfs.tar.xz
   - For example, Web-UI
   - CT template
      1. Click 'Download from Link'
      2. Set URL to 'https://uk.lxd.images.canonical.com/images/oracle/7/amd64/default/20220601_07:46/rootfs.tar.xz'
      3. Set File Name to 'oracle-linux-7.tar.xz'

### Make CT using Web-UI:
2. Click 'Create CT' in upper right
#### Under 'General'
   - Set 'Hostname'
   - Set 'Password'
   - Set 'Confirm password'
#### Under 'Template'
   - Set 'Template' to the file name from the previous step
#### Under 'Network' 
   - Set 'IPv4' to Select Static or DHCP
   - If you select Static, Set 'IPv4/CIDR' and Gateway
   - Set 'IPv6' to Select Static or DHCP or SLAAC
   - If you select Static, Set 'IPv6/CIDR' and Gateway