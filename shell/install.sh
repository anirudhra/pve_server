echo
echo Configuring Timezone...
dpkg-reconfigure tzdata
echo
echo Configuring Locales...
echo
dpkg-reconfigure locales
echo
echo Updating package list and packages...
echo
apt update
apt upgrade
echo
echo Installing packages...
echo
# following section is for PVE server
# apt install vim btop htop duf avahi-daemon avahi-utils alsa-utils cpufrequtils lm-sensors drivetemp vainfo usbutils pciutils intel-gpu-tools autofs
#
# following section is for PVE LXC
apt install vim btop htop duf avahi-daemon avahi-utils autofs nfs-common
#
# following section is if you have audio passthrough in LXC
# apt install alsa-utils
#
# following section is if you have iGPU passthrough in LXC
# foss intel driver - install one of below (only decode)
# apt install intel-media-va-driver vainfo intel-gpu-tools
# non-free intel driver (both decode and encode)
# apt install intel-media-va-driver-non-free vainfo intel-gpu-tools
#
# on kodi hosts, install the following
# apt install kodi-inputstream-adaptive
echo
echo Cleaning up...
echo
apt clean
apt autoclean
apt autoremove
#
echo
echo Configuring shell...
echo
# add aliases
wget -O ~/.aliases https://raw.githubusercontent.com/anirudhra/hpe800g4dm_server/main/shell/dot_pve_aliases
# source aliases in .profile after creating backup
cp ~/.profile ~/.profile.bak
echo "source ~/.aliases" >> ~/.profile
echo
echo Automounting NFS shares in /mnt/nfs-ssd
echo
cp /etc/auto.master /etc/auto.master.bak
cp /etc/auto.mount /etc/auto.mount.bak
mkdir -p /mnt/nfs-ssd
chmod 777 /mnt/nfs-ssd
echo "# manually added for server" >> /etc/auto.master
echo "/- /etc/auto.mount" >> /etc/auto.master
echo "# nfs server mount" >> /etc/auto.mount
echo "/mnt/nfs-ssd -fstype=nfs,rw 10.100.100.50:/mnt/sata-ssd" >> /etc/auto.mount
systemctl daemon-reload
systemctl restart autofs
echo
echo "Done! Logout and log back in for changes"
echo
