## Google Coral TPU M.2/PCIe Driver

Follow installation instructions here until you reach gasket-dkms step: https://coral.ai/docs/m2/get-started/

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

Also includes custom compiled versions of libedgetpu, pycoral and tflite as none from standard Google's repos are compatible with latest python3/linux kernel.

More up-to-date compiled versions are also available in these excellent repos: 
<br>https://github.com/feranick/libedgetpu
<br>https://github.com/feranick/pycoral
<br>https://github.com/feranick/TFlite-builds
