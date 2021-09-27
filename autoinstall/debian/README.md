# NOT READY YET ! ...

- CT's not working
> run_apparmor_parser: 919 Failed to run apparmor_parser on "/var/lib/lxc/100/apparmor/lxc-100_<-var-lib-lxc>": apparmor_parser: Unable to replace "lxc-100_</var/lib/lxc>".  Profile does not conform to protocol
> 
> apparmor_prepare: 1089 Failed to load generated AppArmor profile
> 
> lxc_init: 850 Failed to initialize LSM
> 
> lxc_start: 2007 Failed to initialize container "100"
> 
> TASK ERROR: startup for container '100' failed


- Apparmor unable to load some profiles
> /sbin/apparmor_parser	 Unable to replace "/usr/sbin/chronyd".  Profile does not conform to protocol
> 
> /sbin/apparmor_parser	 Unable to replace "lxc-container-default".  Profile does not conform to protocol
> 
> /sbin/apparmor_parser	 Unable to replace "/usr/bin/lxc-start".  Profile does not conform to protocol
> 
> /sbin/apparmor_parser	 Unable to replace "/usr/sbin/chronyd".  Profile does not conform to protocol
> 
> /sbin/apparmor_parser	 Unable to replace "lxc-container-default".  Profile does not conform to protocol


> Sep 27 00:17:05 VRPi4-PVE-Test apparmor.systemd[3387]: Restarting AppArmor
> 
> Sep 27 00:17:05 VRPi4-PVE-Test apparmor.systemd[3387]: Reloading AppArmor profiles
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: kauditd_printk_skb: 2 callbacks suppressed
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.246:64): apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="lsb_release" pid=3396 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3396]: AVC apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="lsb_release" pid=3396 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.246:65): apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe" pid=3393 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3393]: AVC apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe" pid=3393 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3393]: AVC apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe//kmod" pid=3393 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test apparmor.systemd[3397]: /sbin/apparmor_parser: Unable to replace "/usr/bin/lxc-start".  Profile doesn't conform to protocol
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3397]: AVC apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/bin/lxc-start" pid=3397 comm="apparmor_parser" name="/usr/bin/lxc-start" offset=147
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.246:66): apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe//kmod" pid=3393 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.294:67): apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/bin/lxc-start" pid=3397 comm="apparmor_parser" name="/usr/bin/lxc-start" offset=147
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3394]: AVC apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/sbin/chronyd" pid=3394 comm="apparmor_parser" name="/usr/sbin/chronyd" offset=146
> 
> Sep 27 00:17:05 VRPi4-PVE-Test apparmor.systemd[3394]: /sbin/apparmor_parser: Unable to replace "/usr/sbin/chronyd".  Profile doesn't conform to protocol
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.474:68): apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/sbin/chronyd" pid=3394 comm="apparmor_parser" name="/usr/sbin/chronyd" offset=146
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3395]: AVC apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="lxc-container-default" pid=3395 comm="apparmor_parser" name="lxc-container-default" offset=150
> 
> Sep 27 00:17:05 VRPi4-PVE-Test apparmor.systemd[3395]: /sbin/apparmor_parser: Unable to replace "lxc-container-default".  Profile doesn't conform to protocol
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.934:69): apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined"
> 
> name="lxc-container-default" pid=3395 comm="apparmor_parser" name="lxc-container-default" offset=150
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3414]: AVC apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="lsb_release" pid=3414 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.970:70): apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="lsb_release" pid=3414 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3424]: AVC apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe" pid=3424 comm="apparmor_parser"
> 
> Sep 27 00:17:05 VRPi4-PVE-Test audit[3424]: AVC apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe//kmod" pid=3424 comm="apparmor_parser"
> 
> Sep 27 00:17:06 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.990:71): apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe" pid=3424 comm="apparmor_parser"
> 
> Sep 27 00:17:06 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701825.990:72): apparmor="STATUS" operation="profile_replace" info="same as current profile, skipping" profile="unconfined" name="nvidia_modprobe//kmod" pid=3424 comm="apparmor_parser"
> 
> Sep 27 00:17:06 VRPi4-PVE-Test audit[3431]: AVC apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/bin/lxc-start" pid=3431 comm="apparmor_parser" name="/usr/bin/lxc-start" offset=147
> 
> Sep 27 00:17:06 VRPi4-PVE-Test apparmor.systemd[3431]: /sbin/apparmor_parser: Unable to replace "/usr/bin/lxc-start".  Profile doesn't conform to protocol
> 
> Sep 27 00:17:06 VRPi4-PVE-Test kernel: audit: type=1400 audit(1632701826.042:73): apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/bin/lxc-start" pid=3431 comm="apparmor_parser" name="/usr/bin/lxc-start" offset=147
> 
> Sep 27 00:17:06 VRPi4-PVE-Test audit[3432]: AVC apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="/usr/sbin/chronyd" pid=3432 comm="apparmor_parser" name="/usr/sbin/chronyd" offset=146
> 
> Sep 27 00:17:06 VRPi4-PVE-Test apparmor.systemd[3432]: /sbin/apparmor_parser: Unable to replace "/usr/sbin/chronyd".  Profile doesn't conform to protocol
> 
> Sep 27 00:17:06 VRPi4-PVE-Test audit[3420]: AVC apparmor="STATUS" info="failed to unpack end of profile" error=-71 profile="unconfined" name="lxc-container-default" pid=3420 comm="apparmor_parser" name="lxc-container-default" offset=150
> 
> Sep 27 00:17:06 VRPi4-PVE-Test apparmor.systemd[3420]: /sbin/apparmor_parser: Unable to replace "lxc-container-default".  Profile doesn't conform to protocol
> 
> Sep 27 00:17:06 VRPi4-PVE-Test apparmor.systemd[3387]: Error: At least one profile failed to load
> 
> Sep 27 00:17:06 VRPi4-PVE-Test systemd[1]: apparmor.service: Main process exited, code=exited, status=1/FAILURE
>
