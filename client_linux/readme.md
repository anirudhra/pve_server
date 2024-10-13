Need power management fixes for wifi/bt for suspend: https://wiki.debian.org/InstallingDebianOn/Apple/MacBookPro/Early-2015-13-inch

Need to add 'non-free' repos to all lines in /etc/apt/sources.list

Also need to install bluez-firmware for BT to work.

Install "tlp" package and enable "tlp.service" for dynamic power management and disable usb input devices from powering down.

```
sudo apt install tlp htop btop avahi-daemon cifs-utils nfs-common vim bluez-firmware
```
