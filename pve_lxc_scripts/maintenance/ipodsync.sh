#!/bin/sh
# (c) Anirudh Acharya 2024
# iPod Music and Playlists Sync script
# Run this script from PVE Server (not one of the LXCs or VMs)
# Only one iPod must be connected when the script is invoked
# Script will keep iPod in sync with the music and playlists on the Server/NAS
# This script expects certain paths/names/hostnames etc. to work correctly

# various server directories
server_basesourcedir="/mnt/sata-ssd/ssd-media/media/music"
source_musicdir="${server_basesourcedir}/music"
source_playlistsdir="${server_basesourcedir}/playlists"

# ipod directories/mounts/devices
ipod5g_mountdir="/mnt/IPOD5G"
ipod7g_mountdir="/mnt/IPOD7G"
ipod_mountdir="/mnt/ipod"
ipod_device="/dev/sdb1"
ipod_musicdir="${ipod_mountdir}/music"
ipod_playlistsdir="${ipod_mountdir}/Playlists"

# Check if iPod is attached
# FIXME: Fix this section later
#ipod7g_devid="05ac:1261"
#ipod5g_devid="05ac:1262" #FIXME

#if [[ $(lsusb | grep -i "$ipod7g_devid") && $(lsusb | grep -i "$ipod5g_devid") ]]; then
#    echo "Two iPods are detected! Only one iPod can be connected when this script is invoked, disconnect one and re-run script"
#    exit
#elif [[ $(lsusb | grep -i "$ipod7g_devid") ]]; then
#    echo "Found iPod 7G"
#elif [[ $(lsusb | grep -i "$ipod5g_devid") ]]; then
#    echo "Found iPod 5G"
#else
#    echo "No iPod found!"
#    exit
#fi

# manually mount instead of auto, too many corne cases for now
echo "==============================================================================="
echo "Ensure your iPod is mounted at /mnt/ipod before running this script"
read -p "If not, precc Ctrl+C to exit, mount and rerun. Else Press Enter to continue" -n1 -s
echo "==============================================================================="
# unmount, create mount point (failsafe) and mount ipod
#umount $ipod_device
#mkdir -p "${ipod_mountdir}"
#mount ${ipod_device} ${ipod_mountdir}

ls ${ipod_mountdir}

# sync playlists and music with progress shown
# don't forget the trailing '/' for $ipod_mountdir!
# Can't use -a (which is collection of options) because owner and group are not supported on iPod and will throw errors
rsync -rlptDvP --delete ${source_playlistsdir} ${ipod_mountdir}/

rsync -rlptDvP --delete ${source_musicdir} ${ipod_mountdir}/

# done
echo
echo "==============================================================================="
echo " All done. Manually unmount iPod after verifying with the command: "
echo " umount ${ipod_device} "
echo "==============================================================================="
echo
