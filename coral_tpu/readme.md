## Google Coral TPU M.2/PCIe Driver

Kernel 6.2+ broke google's gasket-dkms Coral TPU driver and the official repo hasn't been update. Compiled driver is available here. Also, instructions for recompiling are provided as necessary. Instructions are from: https://github.com/google-coral/edgetpu/issues/808

```
apt install devscripts debhelper dh-dkms -y
git clone https://github.com/google/gasket-driver.git
cd gasket-driver; debuild -us -uc -tc -b; cd ..
ls -l gasket-dkms*
dpkg -i gasket-dkms_1.0-18_all.deb
ls /dev/apex*
modprobe apex
lsmod | grep apex
```

Output should show /dev/apex_0 device and following modules loaded:
```
apex                   28672  0
gasket                135168  1 apex
```

Custom compiled versions are also available in these excellent repos: 
https://github.com/feranick/libedgetpu
https://github.com/feranick/pycoral
https://github.com/feranick/TFlite-builds
