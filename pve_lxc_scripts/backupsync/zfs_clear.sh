#!/bin/sh
# (c) Anirudh Acharya 2024
# force clears zfs pool if i/o suspended
#

zfspool="pvebackup"

zpool clear -nFX ${zfspool}

zpool status
zfs list
