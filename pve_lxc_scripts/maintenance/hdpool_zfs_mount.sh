#!/bin/sh
#
# (c) Anirudh Acharya 2024
# script to mount usb zfs pool
#
# uncomment -f version if pool fails to mount, else use non-f version
# zpool import hdpool -f
zpool import hdpool

# following command may not be needed all the time, but just in case
zfs set mountpoint=/hdpool hdpool

