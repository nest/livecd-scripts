#!/bin/bash
#
# Environment settings for the live media remastering scripts
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#

# Customizable variables
#
WORKING_ROOT="/srv/images"

DISK_ROOT="temp-cd"
IMAGE_ROOT="extract-cd"
LIVECD_ROOT="squashfs-root"

PREINSTALL_SCRIPT="40_prepare_chroot.sh"
CLEANUP_SCRIPT="60_clean_chroot.sh"

IMAGE_DATE=`date +%y.%m.%d`
IMAGE_NAME="Ubuntu 12.04 i386 NEST"
IMAGE_ORIG="ubuntu-12.04-desktop-i386.iso"
IMAGE_FILE="ubuntu-12.04-desktop-i386-nest-$IMAGE_DATE.iso"

# Misc useful functions
function pause() {
    echo "$*"
    read -p "(Press CTRL+C to abort!)"
}

# Banner with misc info
#
echo "
Make sure that you have installed the needed tools:

    \$ sudo apt-get install squashfs-tools genisoimage

"
