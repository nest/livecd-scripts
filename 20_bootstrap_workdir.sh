#!/bin/bash
#
# This script is expected to be executed as root to unpack the original live media
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#
# Details at https://help.ubuntu.com/community/LiveCDCustomization
#

set -e
set -u

# Read the configuration
#
source 10_environment.sh

# Create the working area
#
mkdir -p $WORKING_ROOT/{$DISK_ROOT,$IMAGE_ROOT}

cd $WORKING_ROOT

# Unpack the original live media
#
mount -o loop $IMAGE_ORIG $DISK_ROOT
rsync --exclude=/casper/filesystem.squashfs -a $DISK_ROOT/ $IMAGE_ROOT

rm -rf $LIVECD_ROOT

unsquashfs $IMAGE_CPUS -d $LIVECD_ROOT $DISK_ROOT/casper/filesystem.squashfs

