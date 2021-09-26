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


