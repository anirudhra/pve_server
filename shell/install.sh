dpkg-reconfigure tzdata
dpkg-reconfigure locales
apt update
apt upgrade
# following section is for PVE server
# apt install vim btop htop duf avahi-daemon avahi-utils alsa-utils cpufrequtils lm-sensors drivetemp vainfo usbutils pciutils intel-gpu-tools autofs
#
# following section is for PVE LXC
apt install vim btop htop duf avahi-daemon avahi-utils alsa-utils autofs
#
# following section is if you have iGPU passthrough in LXC
# foss intel driver - install one of below (only decode)
# apt install intel-media-va-driver vainfo intel-gpu-tools
# non-free intel driver (both decode and encode)
apt install intel-media-va-driver-non-free vainfo intel-gpu-tools
#
# on kodi hosts, install the following
# apt install kodi-inputstream-adaptive
apt clean
apt autoclean
apt autoremove
#
# add aliases
wget https://raw.githubusercontent.com/anirudhra/hpe800g4dm_server/main/shell/dot_pve_aliases ~/.aliases
# source aliases in .profile after creating backup
cp ~/.profile ~/.profile.bak
echo "source ~/.aliases" >> ~/.profile

