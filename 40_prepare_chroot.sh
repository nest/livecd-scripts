#!/bin/bash
#
# This script is run before doing anything in the chroot
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#

set -e
set -u

# Avoid locale-related problems
#
export HOME=/root
export LC_ALL=C

# Mount necessary stuff
#
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

# This is needed for installing packages
#
dbus-uuidgen > /var/lib/dbus/machine-id

dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl


