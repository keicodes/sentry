**Sentry** is a small, fast and agnostic OS for embedded home-made surveillance cameras.

Currently buildale for RaspberryPi 0 W only, but with very few minor tweaks it should work with every Raspberry Pi board.

Once the boot is finished, a camera streaming will be active on 5001 port.

### Parameters

Buildroot: 2019.11 (stable branch)
Kernel: rpi-5.3.y
binutils: 2.32
GCC: 9.2.0 --with-fpu=vfp
libc: musl

Target optimizations used on Raspberry Pi 0 W: -march=armv6zk -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp -fipa-pta, Graphite (-floop-interchange -ftree-loop-distribution -floop-strip-mine -floop-block)

### How to Compile

Remember to set your WiFi and Timezone settings inside build.sh before compiling. This is mandatory if you want an headless start.

Your first build:
```sh
./build.sh -c raspberrypi0w
```

Clean everything and build:
```sh
./build.sh -dc raspberrypi0w
```

To continue a previous build:
```sh
./build.sh -m raspberrypi0w
```

### How to Install

The steps for RaspberryPi 0 W:

1. Attach your camera to RaspberryPi 0 W;

2. Install the compiled image to the SD card using BalenaEtcher, Win32DiskImager or such programs;

3. Start the board and it will take rougly 10 seconds to boot up and get its IP address automatically via DHCP.

### TO-DO

- Allow the configuration of wpa_supplicant.conf from /boot partition
- Support more boards

### Buildroot

Huge thanks to [Buildroot](https://www.buildroot.com) ([github.com/buildroot](https://github.com/buildroot)), which enables these projects to come alive. They deserve so much support.
