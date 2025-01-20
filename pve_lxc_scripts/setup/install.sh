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
if [ "$(id -u)" -ne 0 ]; then
  echo "Script must be run as root!" >&2
  exit 1
fi

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
echo "Installing packages in \"${mode}\" mode..."
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
  'cifs-utils'
  ## all below disabled by default
  #'alsa-utils'
  #'intel-media-va-driver-non-free'
  #'vainfo'
  #'intel-gpu-tools'
  ## for kodi hosts only
  #'kodi-inputstream-adaptive'
)

# for issues with Intel iGPU, read through https://wiki.archlinux.org/title/Intel_graphics for potential issues/solutions
# the following will setup DP-HDMI audio as default in ALSA; works for both PVE host and LXC
#wget -O /etc/asound.conf https://raw.githubusercontent.com/anirudhra/pve_server/main/pve_lxc_scripts/setup/etc/lxc/etc/asound.conf

# install common packages
installer="apt"
$installer install "${common_packages[@]}"

#server side ops and packages
#nfs mount/export
server_nfs="/mnt/sata-ssd"
server_subnet="10.100.100.0/24"
server_ip="10.100.100.50"
client_nfs="/mnt/nfs"

#files
serve_nfs_exports="/etc/exports"
client_auto_master="/etc/auto.master"
client_auto_pveshare="/etc/auto.pveshare"

if [ "${mode}" = "pve" ]; then
  echo "Server specific packages..."
  ${installer} install "${pve_packages[@]}"

  # NFS shares and mounts, export on PVE server
  if grep -wq "${server_nfs} ${server_subnet}" ${serve_nfs_exports}; then
    echo NFS share mount ${server_subnet}:${server_nfs} already exists in ${serve_nfs_exports}!
    echo
  else
    echo Exporting NFS share mounts as ${server_subnet}:${server_nfs}
    echo
    echo "#share ${server_nfs} over nfs" >>${serve_nfs_exports}
    # there should be NO space between the subnet and (nfs_options) below
    echo "${server_nfs} ${server_subnet}(rw,sync,no_subtree_check,no_root_squash,no_all_squash)" >>${serve_nfs_exports}
  fi
#guest side ops and packages - LXC or VMs
else
  echo "Guest specific packages..."
  ${installer} install "${guest_packages[@]}"

  # NFS shares and mounts, LXC clients need to be privileged, else this will fail!
  if grep -wq "${client_nfs} -fstype=nfs" ${client_auto_pveshare}; then
    echo "NFS share mount ${client_nfs} already exists in ${client_auto_pveshare}! Check ${client_auto_master} if it does not work!"
    echo
  else
    echo Automounting NFS share mounts to ${client_nfs}
    echo
    cp "${client_auto_master}" "${client_auto_master}.bak"
    cp "${client_auto_pveshare}" "${client_auto_pveshare}.bak"
    mkdir -p ${client_nfs}
    chmod 777 ${client_nfs}

    echo "# manually added for server" >>${client_auto_master}
    echo "/- ${client_auto_pveshare}" >>${client_auto_master}
    echo "# nfs server mount" >>${client_auto_pveshare}
    echo "${client_nfs} -fstype=nfs,rw ${server_ip}:${server_nfs}" >>${client_auto_pveshare}
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
source_aliases="source ${HOME}/.aliases"
shell_profile="${HOME}/.profile"

if grep -wq "${source_aliases}" "${shell_profile}"; then
  echo "Aliases file already sourced"
else
  # source aliases in shell profile after creating backup
  cp "${shell_profile}" "${shell_profile}.bak"
  echo "${source_aliases}" >>"${shell_profile}"
  # use the unified dot files from dotfiles repo, works for all platforms now
  wget -O ~/.aliases https://raw.githubusercontent.com/anirudhra/dotfiles/refs/heads/main/home/.aliases
fi

echo
echo "Done! Logout and log back in for changes"
echo

# end of script
#
