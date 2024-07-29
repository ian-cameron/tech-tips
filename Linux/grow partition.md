Say you have a VM, and run out of space.  Then you need to grow the space.  eg)
```
~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               7.8G     0  7.8G   0% /dev
tmpfs                              1.6G  1.7M  1.6G   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   78G   68G  6.4G  92% /
tmpfs                              7.9G     0  7.9G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              7.9G     0  7.9G   0% /sys/fs/cgroup
/dev/sda2                          974M  209M  698M  24% /boot


:~$ sudo fdisk -l
...
Disk /dev/sda: 80 GiB, 85899345920 bytes, 167772160 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: BB76B0C6-7828-433F-B315-651224CEE25D

Device       Start       End   Sectors Size Type
/dev/sda1     2048      4095      2048   1M BIOS boot
/dev/sda2     4096   2101247   2097152   1G Linux filesystem
/dev/sda3  2101248 167772126 165670879  79G Linux LVM


Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 78.101 GiB, 84808826880 bytes, 165642240 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

...

```

So you ask your IT to add space to the virtual disk and you reboot.  But you still have the same thing.  You can see the empty space on the physical disk and can grow the partition:
```
~$ sudo growpart /dev/sda 3
CHANGED: partition=3 start=2101248 old: size=165670879 end=167772127 new: size=375386079 end=377487327

~$ sudo fdisk -l
Disk /dev/sda: 180 GiB, 193273528320 bytes, 377487360 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: BB76B0C6-7828-433F-B315-651224CEE25D

Device       Start       End   Sectors  Size Type
/dev/sda1     2048      4095      2048    1M BIOS boot
/dev/sda2     4096   2101247   2097152    1G Linux filesystem
/dev/sda3  2101248 377487326 375386079  179G Linux LVM


Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 78.101 GiB, 84808826880 bytes, 165642240 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
But your volume group is still the same small size:
```
~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  12
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <79.00 GiB
  PE Size               4.00 MiB
  Total PE              20223
  Alloc PE / Size       20223 / <79.00 GiB
  Free  PE / Size       0 / 0
  VG UUID               VjMw7I-LZoA-Eqm5-ERIE-Gtee-dfKn-vj7YtH

~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                wDsT7s-jKQJ-QbCX-pKYN-A4Jf-OcG2-W3Nu2t
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2021-01-29 15:26:57 -0800
  LV Status              available
  # open                 1
  LV Size                <79.00 GiB
  Current LE             20223
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

```
 After adding space on the host and growing the partition you'll need to extend the volume group and grow the logical partition size, and then resize the filesystem.  These 3 commands will do it:

```
~$ sudo  pvresize /dev/sda3
  Physical volume "/dev/sda3" changed
  1 physical volume(s) resized or updated / 0 physical volume(s) not resized

~$ sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
  Size of logical volume ubuntu-vg/ubuntu-lv changed from <79.00 GiB (20223 extents) to <179.00 GiB (45823 extents).
  Logical volume ubuntu-vg/ubuntu-lv successfully resized.

~$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs 1.45.5 (07-Jan-2020)
Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
old_desc_blocks = 10, new_desc_blocks = 23
The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 46922752 (4k) blocks long.

~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               7.8G     0  7.8G   0% /dev
tmpfs                              1.6G  1.7M  1.6G   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  177G   68G  101G  41% /
tmpfs                              7.9G     0  7.9G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              7.9G     0  7.9G   0% /sys/fs/cgroup
/dev/sda2                          974M  209M  698M  24% /boot
...
```