#!/bin/sh

set -u
set -e

# Board hook
sh "../board/${BOARD}/hook.sh"

# Copy /etc
cp -rf "../board/common/etc" "${TARGET_DIR}/"

# Mount /boot partition
mkdir -p "${TARGET_DIR}/boot"

if ! grep -q "/boot" "${TARGET_DIR}/etc/fstab"; then
	echo "/dev/mmcblk0p1 /boot vfat defaults 0 0" >> "${TARGET_DIR}/etc/fstab"
fi

# Copy wpa_supplicant.conf to the /boot partition
cp "../board/common/wpa_supplicant.conf" "${BINARIES_DIR}/rpi-firmware/"

