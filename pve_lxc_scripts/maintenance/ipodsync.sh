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
ipod5g_device="/dev/sdb2" #FIXME: /dev/sdX2
ipod7g_device="/dev/sdb1" #FIXME: /dev/sdX1
ipod_musicdir="${ipod_mountdir}/music"
ipod_playlistsdir="${ipod_mountdir}/playlists"

######################################################################3
# Check if iPod is attached
# FIXME: Fix this entire section later
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
######################################################################3

######################################################################3
# unmount, create mount point (failsafe) and mount ipod
#umount $ipod_device
#mkdir -p "${ipod_mountdir}"
#mount ${ipod_device} ${ipod_mountdir}
#ls ${ipod_mountdir}

# manually mount instead of auto, too many corne cases for now
# ipod7g has /dev/sdX1 as the partition while ipod5g has /dev/sdX2 as the partition
echo
echo "==============================================================================="
echo "Contents of ${ipod_mountdir}:"
echo
ls ${ipod_mountdir}
echo
echo "==============================================================================="
echo "Disk space usage of ${ipod_mountdir}"
df -h ${ipod_mountdir}
echo "==============================================================================="
echo
echo "==============================================================================="
echo "Ensure your iPod is mounted at ${ipod_mountdir} before running this script"
echo
echo "For iPod5G: mount /dev/sdX2 ${ipod_mountdir}"
echo "For iPod7G: mount /dev/sdX1 ${ipod_mountdir}"
echo
echo "If not, precc Ctrl+C to exit, mount and rerun. Else Press Enter to continue"
echo "==============================================================================="
echo

# read into dummy variable to pause
read answer

######################################################################3
# sync playlists and music with progress shown
# don't forget the trailing '/' for $ipod_mountdir!
# Can't use -a (archive) because owner and group are not supported on iPod/vfat/fat32 and will throw errors
# Instead use "-hvrltD --modify-window=1" options specifically for exfat/fat32 fs
echo "Syncing playlists..."
echo
rsync -hvrltD --modify-window=1 --delete ${source_playlistsdir} ${ipod_mountdir}/

echo
echo "Syncing music..."
echo
# sync music files
rsync -hvrltD --modify-window=1 --delete ${source_musicdir} ${ipod_mountdir}/

######################################################################3
# done
echo
echo "==============================================================================="
echo " All done. Manually unmount iPod after verifying with the command: "
echo " umount ${ipod_mountdir}"
echo "==============================================================================="
echo

# end of script
