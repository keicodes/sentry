#!/bin/sh

set -u
set -e

# Overwrite config files
cp -rf "../board/raspberrypi0w/rpi-firmware" "${BINARIES_DIR}"

# Fix for fixup_x.dat start_x.elf not being correctly named
[ -f "${BINARIES_DIR}/rpi-firmware/fixup.dat" ] && mv "${BINARIES_DIR}/rpi-firmware/fixup.dat" "${BINARIES_DIR}/rpi-firmware/fixup_x.dat"
[ -f "${BINARIES_DIR}/rpi-firmware/start.elf" ] && mv "${BINARIES_DIR}/rpi-firmware/start.elf" "${BINARIES_DIR}/rpi-firmware/start_x.elf"

