#!/bin/sh
#
# (c) Anirudh Acharya 2024
# Script to backup PVE server
# Used in conjunction with exclude_pve_zfs_backup.txt to specify exclusions
# Before backing up mount external USB ZFS with zfs_mount.sh script and after
# backup, unmount the ZFS fs and export the pool cleanly with zfs_umount.sh script before 
# disconnecting to avoid data loss
#
# mv /hdpool/fs/log/server_backup.log /hdpool/fs/log/server_backup_prev.log
#
# add all exclusion directories to the _exclude external file below, all output logged to file
# verbose version of above
#
rsync -avHPAX --delete --exclude-from='./exclude_pve_zfs_backup.txt' /mnt/sata-ssd /zfsdata/pve_backup
