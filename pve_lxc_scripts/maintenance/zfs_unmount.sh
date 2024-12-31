#!/bin/sh
# (c) Anirudh Acharya 2024
# unmounts hdpool filesystem - first step (does not remove the pool)
#
zfs umount /pvebackup
# exports the zpool to make it safe to USB disconnect after unmount 
zpool export pvebackup
