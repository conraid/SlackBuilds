README for nmon15a Feb 2015
---------------------------
Adding new larger functions so increment the version number to 15
- Roughly 200 new lines of code and 500 changes.
- Only try this beta version if:
	Using PowerKVM host or guest, 
	Want initial online splash screen improvements
	Want improved NFS stats
	Want to collect new commands in the output file
  Only releasing the source code at the moment.
  If you want to try it you need to recompile it yourself - it is easy.

Next version 15b to have some disk duplication reduction due to /proc/diskstats duplication
	for example sda AND sda1 and multipath disks

Only then do I suggest trying to recompile binaries to the download site.

New features in nmon15a - are below

On screen New PowerKVM and splash screen
- Original PowerVM host environment supported
- PowerKVM host environment supported
	/proc/ppc64/lparcfg is missing and SMT is switched off even is guests have it one
- PowerKVM guest environment supported
	/proc/ppc64/lparcfg - probably mostly missing (1.9)
- Native guest environment supported - not virtualised

Support Big and Little Endian - for POWER machines that can run both
- No code changes as such but we search out various places to find out what we 
	are running on so we can tell the user on the initial splash screen

Other splash screen improvements are trying to display (depending if relavant and available)
- GHz
- PowerVM: Entitlement, Virtual CPUs, Logical CPUs, SMT, Capped
- Number of CPUs and/or CPU cores
- x86 bogomips
- x86 Hyperthreads

Added commands for start up config BBB section for output file
lsblk - like fdisk list but shows releationships
lscpu - outputs CPU type extra but very inconsistent between distro and even disto versions
lshw  - Loads of extra hardware info is wacko format

NFS client and server support rewrite
- The /proc NFS stats are a mess with a dozen different numbers of fields found
	Anywhere from 40 to 59 at the time of writing Feb 2015.
- Its an nightmare trying to workout the currently running Linux supports.
- In addition files and rows can come and go depending on whether NFS client or NFS server 
	or specific NFS versions are currently active.
- The only saving grace is the growing number of variables are in a consistent order
- The stats names / meanings are not documented with /proc
	We have to assume that are the same order as the output from the nfsstat command
- So know we have to count the numbers of stats to determine what we have and can display.
- By the time nmon15 is ready for production use they will have added yet more stats!
- NFS on screen changed to display as many as possible stats.
- NFS to file output should write as many as we found in /proc

Any other ideas please get in touch, cheers @mr_nmon (Nigel Griffiths) nag@uk.ibm.com
 

