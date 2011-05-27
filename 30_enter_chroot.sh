#!/bin/bash
#
# This script is expected to be executed as root to get into the chroot
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#

set +u

SCRIPT_TO_RUN="$1"

set -e
set -u

# Read the configuration
#
source 10_environment.sh

# Copy DNS settings from the host
#
cp -f /etc/resolv.conf $WORKING_ROOT/$LIVECD_ROOT/etc

# Mount necessary special-purpose file systems
#
mount --bind /dev $WORKING_ROOT/$LIVECD_ROOT/dev

# Put a preinstall/cleanup script inside the chroot
#
OUR_DIR=`dirname $0`

cp -f $OUR_DIR/$PREINSTALL_SCRIPT $WORKING_ROOT/$LIVECD_ROOT
cp -f $OUR_DIR/$CLEANUP_SCRIPT $WORKING_ROOT/$LIVECD_ROOT

chmod ugo+x $WORKING_ROOT/$LIVECD_ROOT/$PREINSTALL_SCRIPT
chmod ugo+x $WORKING_ROOT/$LIVECD_ROOT/$CLEANUP_SCRIPT

# Run the pre-install script inside the chroot
#
chroot $WORKING_ROOT/$LIVECD_ROOT /$PREINSTALL_SCRIPT

# Either just chroot or also run a script inside
#
if [ -z "$SCRIPT_TO_RUN" ]; then

    pause "Changing the root to $LIVECD_ROOT"
    chroot $WORKING_ROOT/$LIVECD_ROOT

else

    SCRIPT_FULL=$1
    SCRIPT_NAME=`basename $1`

    cp -f $SCRIPT_FULL $WORKING_ROOT/$LIVECD_ROOT
    chmod ugo+x $WORKING_ROOT/$LIVECD_ROOT/$SCRIPT_NAME

    echo "Now please make sure that the relevant archives are already in /usr/src, i.e. NEST"

    pause "Changing the root to $LIVECD_ROOT to run script $SCRIPT_NAME inside..."

    chroot $WORKING_ROOT/$LIVECD_ROOT /$SCRIPT_NAME

    echo "Cleaning up..."

    rm -f $WORKING_ROOT/$LIVECD_ROOT/$SCRIPT_NAME

fi

# Run the cleanup script inside the chroot
#
chroot $WORKING_ROOT/$LIVECD_ROOT /$CLEANUP_SCRIPT

rm -f $WORKING_ROOT/$LIVECD_ROOT/$PREINSTALL_SCRIPT
rm -f $WORKING_ROOT/$LIVECD_ROOT/$CLEANUP_SCRIPT

# Can not do that inside the chroot
#
umount $WORKING_ROOT/$LIVECD_ROOT/dev

