#!/bin/sh

set -u
set -e

# Overwrite config files
cp -rf "../board/raspberrypi0w/boot/cmdline.txt" "${BINARIES_DIR}/rpi-firmware/"
cp -rf "../board/raspberrypi0w/boot/config.txt" "${BINARIES_DIR}/rpi-firmware/"

# Fix for fixup_x.dat start_x.elf not being correctly named
[ -f "${BINARIES_DIR}/rpi-firmware/fixup.dat" ] && mv "${BINARIES_DIR}/rpi-firmware/fixup.dat" "${BINARIES_DIR}/rpi-firmware/fixup_x.dat"
[ -f "${BINARIES_DIR}/rpi-firmware/start.elf" ] && mv "${BINARIES_DIR}/rpi-firmware/start.elf" "${BINARIES_DIR}/rpi-firmware/start_x.elf"

