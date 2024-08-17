# HP Elitedesk 800 G4 Mini Server files (hpe800g4dm_server)

1) UEFI 2.27 introduces an issue with displayport pin mapping. Linux does not see audio through displayport and hence needs explicit patching until kernel includes it by default (not as of 6.8.12)
2) Kodi Proxmox LXC script
   Script modified from: https://github.com/mrrudy/proxmoxHelper to install livestream plugin (apt install kodi-inputstream-adaptive)
3) Shell scripts and aliases
4) PVE Helper scripts (more available at https://tteck.github.io/Proxmox/)
5) LXC GPU, Sound and Keyboard passthrough template
6) asound.conf to set DP/HDMI as the default audio device
7) Updated ariel.ttf with UTF8 and devanagari support. Replace /usr/share/kodi/media/Fonts/ariel.ttf with this one after backing up

## LXC Environment automation:

Use this command to run off github:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/anirudhra/hpe800g4dm_server/main/shell/install.sh)"
```

Use this command to copy locally:
```
wget https://raw.githubusercontent.com/anirudhra/hpe800g4dm_server/main/shell/install.sh
```

## LXC autologin in PVE Console
Type the following in LXC console to enable auto login:

```
GETTY_OVERRIDE="/etc/systemd/system/container-getty@1.service.d/override.conf"
mkdir -p $(dirname $GETTY_OVERRIDE)
cat <<EOF >$GETTY_OVERRIDE
  [Service]
  ExecStart=
  ExecStart=-/sbin/agetty --autologin root --noclear --keep-baud tty%I 115200,38400,9600 \$TERM
EOF
systemctl daemon-reload
systemctl restart $(basename $(dirname $GETTY_OVERRIDE) | sed 's/\.d//')
```

## HDMI/DP Audio patch on PVE server
Apple the firmware patch to activate pin 6 for audio

## Install Kodi on LXC
Use this command:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/anirudhra/hpe800g4dm_server/main/kodi_lxc_proxmoxHelper/ct/kodi-v1.sh)"
```

This custom update to the original script uses Ubuntu 24.04 instead of older version

## Drive temp on PVE Server
before running sensors-detect, run 'modprobe drivetemp' for SATA HDDs

## Enabling IOMMU/VT-d Virtualization on PVE Server

(https://pve.proxmox.com/wiki/PCI(e)_Passthrough)

1) Add intel_iommu=on and iommu=pt to /etc/default/grub: GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"
2) Run:
```
   upgrade-grub
```
4) Add following modules to /etc/modules:
```
 vfio
 vfio_iommu_type1
 vfio_pci
 vfio_virqfd #not needed if on kernel 6.2 or newer
```
6) Run:
```
   update-initramfs -u -k all
```
8) Reboot
9) Check:
```
   dmesg | grep -i -e DMAR -e IOMMU
   lsmod | grep -i vfio
   cat /proc/cmdline
```

## Full Kernel Command line on PVE Server:
/etc/default/grub: Kernel command line:
```
   BOOT_IMAGE=/boot/vmlinuz-6.8.12-1-pve root=/dev/mapper/pve-root ro quiet i915.enable_gvt=1 i915.enable_guc=3 intel_pstate=active intel_iommu=on iommu=pt
```
