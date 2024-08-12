# HP Elitedesk 800 G4 Mini Server files (hpe800g4dm_server)

1) UEFI 2.27 introduces an issue with displayport pin mapping. Linux does not see audio through displayport and hence needs explicit patching until kernel includes it by default (not as of 6.8.12)
2) Kodi Proxmox LXC script
   Script modified from: https://github.com/mrrudy/proxmoxHelper to install livestream plugin
3) Shell scripts and aliases
4) PVE Helper scripts (more available at https://tteck.github.io/Proxmox/)
5) LXC GPU, Sound and Keyboard passthrough template
6) asound.conf to set DP/HDMI as the default audio device
7) Updated ariel.ttf with UTF8 and devanagari support. Replace /usr/share/kodi/media/Fonts/ariel.ttf with this one after backing up

## Enabling IOMMU/VT-d Virtualization

(https://pve.proxmox.com/wiki/PCI(e)_Passthrough)

1) Add intel_iommu=on and iommu=pt to /etc/default/grub: GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"
2) Run: upgrade-grub
3) Add following modules to /etc/modules <br>
 vfio <br>
 vfio_iommu_type1 <br>
 vfio_pci <br>
 vfio_virqfd #not needed if on kernel 6.2 or newer <br>
4) Run: update-initramfs -u -k all
5) Reboot
6) Check: <br>
   dmesg | grep -i -e DMAR -e IOMMU <br>
   lsmod | grep -i vfio <br>
   cat /proc/cmdline <br>
   
