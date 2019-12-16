#!/bin/bash

export BOARD=""

# Buildroot
S_BUILDROOT_BRANCH="2019.11"

# Kernel
S_KERNEL_URL="https://github.com/raspberrypi/linux.git"
S_KERNEL_VERSION="rpi-5.3.y"

# Timezone
S_LOCALTIME="Etc/UTC"

# WiFi
S_NETWORK_COUNTRY="gb"
S_NETWORK_SSID="YOUR_SSID"
S_NETWORK_PASSWORD="YOUR_LONG_AND_SECURE_PASSWORD"

# Check board compatibility
function check-board {
	if [ $1 == "raspberrypi0w" ]; then
		export BOARD=$1
	else
		echo "Board not recognized or supported"
	fi
}

# Set specific board configs
function set-board-configs {
	echo "Using ${BOARD} configurations"

	# defconfig
	cp "board/${BOARD}/configs/${BOARD}_defconfig" "buildroot/configs/"

	# hook
	echo "sh ../board/configure.sh" >> "buildroot/board/${BOARD}/post-build.sh"
}

# Apply custom board patches, if there are any
function apply-patches {
	echo "Applying patches"

	for i in board/${BOARD}/patches/*.patch;
	do
		echo "  - $i"
		patch -p0 < $i
	done
}

# Apply our custom settings
function set-configs {
	# Kernel
	sed -i "s#\(BR2_LINUX_KERNEL_CUSTOM_REPO_URL=\).*#\1\"$S_KERNEL_URL\"#" "board/${BOARD}/configs/${BOARD}_defconfig"
	sed -i "s#\(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION=\).*#\1\"$S_KERNEL_VERSION\"#" "board/${BOARD}/configs/${BOARD}_defconfig"

	# Kernel config
	sed -i "s#\(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=\).*#\1\"../board/${BOARD}/configs/kernel_defconfig\"#" "board/${BOARD}/configs/${BOARD}_defconfig"

	# Timezone
	sed -i "s#\(BR2_TARGET_LOCALTIME=\).*#\1\"$S_LOCALTIME\"#" "board/${BOARD}/configs/${BOARD}_defconfig"

	# wpa_supplicant.conf
	sed -i "s/\(country=\).*/\1$S_NETWORK_COUNTRY/" "board/common/etc/wpa_supplicant.conf"
	sed -i "s/\(ssid=\).*/\1\"$S_NETWORK_SSID\"/" "board/common/etc/wpa_supplicant.conf"
	sed -i "s/\(psk=\).*/\1\"$S_NETWORK_PASSWORD\"/" "board/common/etc/wpa_supplicant.conf"
}

# Clean buildroot clone
function clean-buildroot {
	rm -rf buildroot
}

function move-image {
	sleep 1

	[ -f "output/images/sdcard.img" ] && mv "output/images/sdcard.img" "../sentry.img"
}

# Wrap up everything for compilation
function compile {
	# Remove old img
	[ -f "sentry.img" ] && rm sentry.img

	# Get Buildroot
	[ ! -d "buildroot" ] && git clone -b $S_BUILDROOT_BRANCH https://github.com/buildroot/buildroot.git

	# Agnostic settings
	set-configs

	# Board settings
	set-board-configs ${BOARD}

	# Apply specific board patches
	apply-patches

	cd buildroot
	make ${BOARD}_defconfig
	make V=1

	move-image
}

function display-help {
	echo "Usage: ./build.sh [OPTION]"
	echo
	echo "  -h			display this help"
	echo "  -c BOARD		compile the specific board"
	echo "  -d			deletes buildroot"
	echo "  -m BOARD		make, without cleaning anything"
}

while getopts "hdm:c:" OPT
do
	case $OPT in
		h)
			display-help

			exit 0
			;;
		c)
			check-board $OPTARG

			if [ ! -z $BOARD ]; then
				compile $BOARD
			fi
			;;
		d)
			clean-buildroot
			;;
		m)
			check-board $OPTARG

			if [ ! -z $BOARD ]; then
				cd buildroot
				make && move-image
			fi

			exit 0
			;;
		*)
			display-help

			exit 0
			;;
	esac
done

if [ "$OPTIND" -eq "1" ]; then
	display-help
fi

exit 0
