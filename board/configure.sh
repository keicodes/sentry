#!/bin/sh

set -u
set -e

# Board hook
sh "../board/${BOARD}/hook.sh"

# Copy /etc
cp -rf "../board/common/etc" "${TARGET_DIR}/"

