## Google Coral TPU M.2/PCIe Driver

Follow installation instructions here until you reach gasket-dkms step: https://coral.ai/docs/m2/get-started/

## Kernel Driver
Kernel 6.2+ broke google's gasket-dkms Coral TPU driver and the official repo hasn't been updated since. Compiled driver is provided in this repo. Also, instructions for recompiling are provided here: https://github.com/google-coral/edgetpu/issues/808

```
apt install devscripts debhelper dh-dkms -y
git clone https://github.com/google/gasket-driver.git
cd gasket-driver; debuild -us -uc -tc -b; cd ..
ls -l gasket-dkms*
dpkg -i gasket-dkms_1.0-18_all-<kernel>.deb
```

For compiled drivers available in this repo, install as:
```
dpkg -i gasket-dkms_1.0-18_all-kernel-6.2plus.deb
```

## Edge TPU Library
Install one of the included Edge TPU libraries. DON'T install both. For standard clocked TPU, install:

```
dpkg -i libedgetpu1-std_16.0tf2.17.0-1.ubuntu24.04_amd64.deb
```
OR for max clocked TPU (ensure good cooling), install:
```
dpkg -i libedgetpu1-max_16.0tf2.17.0-1.ubuntu24.04_amd64.deb
```

After install, verify by:

```
ls /dev/apex*
modprobe apex
lsmod | grep apex
```

Output should show apex device and following modules loaded:
```
/dev/apex_0
apex                   28672  0
gasket                135168  1 apex
```

More up-to-date compiled versions are also available in these excellent repos: 
<br>https://github.com/feranick/libedgetpu
<br>https://github.com/feranick/pycoral
<br>https://github.com/feranick/TFlite-builds

## Installing python libraries

Instructions to install python 3.12 libraries provided in this repo (will only work with 3.12; for other versions download from the repos above). You need to install python<ver>-venv package for this work.

One time venv creation:
```
mkdir <venv>
cd <venv>
python3 -m venv <venv>
```

Sourcing virtual environment every other time:
```
source ./<venv>/bin/activate
```

```
<venv>/bin/python3 -m pip install ./tflite_runtime-2.17.0-cp312-cp312-linux_x86_64.whl
<venv>/bin/python3 -m pip install ./pycoral-2.0.2-cp312-cp312-linux_x86_64.whl
<venv>/bin/python3 -m pip install tensorflow
```

## Edge TPU repo

Add Edge TPU repo and import key:

```
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
apt-get update
apt-get install edgetpu-compiler
```

This will allow you to install tools like Edge TPU compiler etc.

## Model visualization script

Original source: https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/lite/tools/visualize.py

File included in this repo for convenience. Helps visualize tensorflow lite operations. Syntax (source venv activation first):
```
<venv>/bin/python3 ./tflite_visualize.py <tflitemodel.tflite> <output.html>
```
Will produce <output.html> with tflite ops visualization
