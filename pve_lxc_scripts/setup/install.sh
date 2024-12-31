#!/bin/bash
# (c) Anirudh Acharya 2024
# Sets up PVE host and/or LXC container for basic usage
# This script must be run as root on PVE Server and LXC/VMs
# Not running as bash or zsh will cause this script to fail as "sh" does not support arrays!

mode="none"

# validate inputs
if [ $# -ne 1 ]; then
    echo "Usage: $0 pve or $0 guest"
    exit 1
else
   if [ "$1" = "pve" ]; then
     echo "Script invoked in PVE server mode"
   elif [ "$1" = "guest" ]; then
     echo "Script invoked in Guest mode"
   else	
    echo "Usage: $0 pve or $0 guest"
    exit 1
   fi
   mode=$1
fi

# must be root
if [ "$(id -u)" -ne 0 ]; then echo "Script must be run as root!" >&2; exit 1; fi

# Configure console font and size, esp. usefull for hidpi displays (select Combined Latin, Terminus, 16x32 for legibility
echo
# echo Configuring Console...
dpkg-reconfigure console-setup
# Configure timezone and locale for en/UTF-8
echo
echo Configuring Timezone...
dpkg-reconfigure tzdata
echo
echo Configuring Locales...
echo
dpkg-reconfigure locales
echo

# Perform OS update and upgrade
echo Updating package list and packages...
echo
apt update
apt upgrade

echo
echo Installing packages in \"$mode\" mode...
echo

common_packages=( 
   'neovim'
   'btop'
   'avahi-daemon'
   'avahi-utils'
   'duf'
   'nfs-common'
   'tmux'
   'screen'
   'reptyr'
   'ncdu'
   'autofs'
)

pve_packages=(
   'inxi'
   'git'
   'gh'
   'alsa-utils'
   'cpufrequtils'
   'nfs-kernel-server'
   'lm-sensors'
   'powertop'
   'usbutils'
   'pciutils'
   'iperf3'
   'intel-media-va-driver-non-free'
   'vainfo'
   'intel-gpu-tools'
)

guest_packages=(
   'htop'
)

# for issues with Intel iGPU, read through https://wiki.archlinux.org/title/Intel_graphics for potential issues/solutions
# the following will setup DP-HDMI audio as default in ALSA; works for both PVE host and LXC
#wget -O /etc/asound.conf https://raw.githubusercontent.com/anirudhra/pve_server/main/pve_lxc_scripts/setup/etc/lxc/etc/asound.conf

# install common packages
installer="apt"
$installer install "${common_packages[@]}"

#server side ops and packages
if [ $mode = "pve" ]; then
   echo "Server specific packages..."
   $installer install "${pve_packages[@]}"

   # NFS shares and mounts, export on PVE server
   if grep -wq "/mnt/sata-ssd 10.100.100.0/24" /etc/exports; then
     echo NFS share mounts as IPaddr:/mnt/sata-ssd already exist!
     echo
   else
     echo Exporting NFS share mounts as IPaddr:/mnt/sata-ssd
     echo
     echo "#share sata-ssd over nfs" >> /etc/exports
     echo "/mnt/sata-ssd 10.100.100.0/24(rw,sync,no_subtree_check,no_root_squash,no_all_squash)" >> /etc/exports
   fi
#guest side ops and packages
else
   echo "Guest specific packages..."
   $installer install "${guest_packages[@]}"
   
   # disabled by default unless audio is passed through in VM/LXC
   #$installer install alsa-utils
   
   # disabled by default unless GPU is passed through in VM/LXC
   #$installer install intel-media-va-driver-non-free vainfo intel-gpu-tools
   
   # on kodi hosts, install the following
   #sudo apt install kodi-inputstream-adaptive

   # NFS shares and mounts, LXC clients need to be privileged, else this will fail!
   if grep -wq "/mnt/server -fstype=nfs" /etc/auto.mount; then
     echo "NFS share mount /mnt/server already exists in /etc/auto.mount! Check /etc/auto.master if it does not work!"
     echo
   else
     echo Automounting NFS share mounts in /mnt/server
     echo
     cp /etc/auto.master /etc/auto.master.bak
     cp /etc/auto.mount /etc/auto.mount.bak
     mkdir -p /mnt/server
     chmod 777 /mnt/server
   
     echo "# manually added for server" >>/etc/auto.master
     echo "/- /etc/auto.mount" >>/etc/auto.master
     echo "# nfs server mount" >>/etc/auto.mount
     echo "/mnt/server -fstype=nfs,rw 10.100.100.50:/mnt/sata-ssd" >>/etc/auto.mount
   fi
fi

#restart autofs
systemctl daemon-reload
systemctl restart autofs

echo
echo Cleaning up...
echo
apt clean
apt autoclean
apt autoremove

echo
echo Configuring shell aliases...
echo

# add useful aliases to profile, works for bash and zsh
if grep -wq "source ~/.aliases" ~/.profile; then 
  echo "Aliases file already sourced"
else
  # source aliases in .profile after creating backup
  cp ~/.profile ~/.profile.bak
  echo "source ~/.aliases" >>~/.profile
  # use the unified dot files from dotfiles repo, works for all platforms now
  wget -O ~/.aliases https://raw.githubusercontent.com/anirudhra/dotfiles/refs/heads/main/home/.aliases
fi

echo
echo "Done! Logout and log back in for changes"
echo

# end of script

