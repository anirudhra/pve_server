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

zfspool="pvebackup"
mountpoint="zfsdata"

#confirm backup destination is available and correct
echo
echo "==============================================================================="
echo "Contents of destination: ${zfspool}/${mountpoint}:"
echo
ls ${zfspool}/${mountpoint}
echo
echo "==============================================================================="
echo "Disk space usage of destination: ${zfspool}/${mountpoint}"
df -h ${zfspool}/${mountpoint}
echo "==============================================================================="
echo
echo "==============================================================================="
echo "Ensure your backup destination is mounted correctly before running this script"
echo "Backup desitnation: ${zfspool}/${mountpoint}"
echo
echo "If not, press Ctrl+C to exit, mount and rerun. Else Press Enter to continue"
echo "==============================================================================="
echo

# read into dummy variable to pause
read answer

rsync -avHPAX --delete --exclude-from='./exclude_pve_zfs_backup.txt' /mnt/sata-ssd /zfsdata/pve_backup
