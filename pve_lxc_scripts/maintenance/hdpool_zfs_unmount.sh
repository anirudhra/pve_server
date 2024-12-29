#!/bin/sh
# unmounts hdpool filesystem (does not remove the pool)
zfs umount /hdpool/fs
# exports the zpool to make it safe to remove
zpool export hdpool
