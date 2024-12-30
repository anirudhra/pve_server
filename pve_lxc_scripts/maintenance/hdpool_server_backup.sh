#!/bin/sh
#
# (c) Anirudh Acharya 2024
# Script to backup PVE server
# Used in conjunction with hppool_server_backup_exclude.txt to specify exclusions
#
# mv /hdpool/fs/log/server_backup.log /hdpool/fs/log/server_backup_prev.log
#
# add all exclusion directories to the _exclude external file below, all output logged to file
# verbose version of above
#
rsync -avHPAX --delete --exclude-from='./hdpool_server_backup_exclude.txt' /mnt/sata-ssd /hdpool/fs/server_backup
