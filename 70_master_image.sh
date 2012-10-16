#!/bin/bash
#
# This script is to be executed to produce new master image
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#

set -e
set -u

# Read the configuration
#
source 10_environment.sh

cd $WORKING_ROOT

# Fix permissions (just in case)
#
chown root:src -R $LIVECD_ROOT/usr/src

# Create the list of installed packages
#
chroot $LIVECD_ROOT dpkg-query -W --showformat='${Package} ${Version}\n' | tee $IMAGE_ROOT/casper/filesystem.manifest

cp $IMAGE_ROOT/casper/filesystem.manifest $IMAGE_ROOT/casper/filesystem.manifest-desktop

sed -i '/ubiquity/d' $IMAGE_ROOT/casper/filesystem.manifest-desktop
sed -i '/casper/d' $IMAGE_ROOT/casper/filesystem.manifest-desktop

# Update the compressed root file system
#
rm -f $IMAGE_ROOT/casper/filesystem.squashfs

mksquashfs $LIVECD_ROOT $IMAGE_ROOT/casper/filesystem.squashfs $IMAGE_CPUS
chmod ugo-x $IMAGE_ROOT/casper/filesystem.squashfs

printf $(du -sx --block-size=1 $LIVECD_ROOT | cut -f1) | tee $IMAGE_ROOT/casper/filesystem.size

# Generate the checksums of the ISO contents
#
rm $IMAGE_ROOT/md5sum.txt
cd $IMAGE_ROOT
find -type f -print0 | xargs -0 md5sum | grep -v ./isolinux | tee md5sum.txt

# Actually master the image
#
mkisofs \
    -D -r -V "$IMAGE_NAME" \
    -cache-inodes -J -l \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -o ../$IMAGE_FILE .

