#!/bin/sh
# (c) Anirudh Acharya 2024
# unmounts hdpool filesystem - first step (does not remove the pool)
#
zfs umount /hdpool/fs
# exports the zpool to make it safe to USB disconnect after unmount 
zpool export hdpool
