#!/bin/bash
#
# This script is to be executed to clean up the chroot
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#

set +e
set -u

# Remove DNS settings
#
rm -f /etc/resolv.conf

# Clean up APT caches
#
aptitude purge ~c
apt-get clean

# Revert stuff for packages
#
rm /var/lib/dbus/machine-id

rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

# Remove misc stuff
#
rm -rf /tmp/* /tmp/.*
rm -rf /root/* /root/.*

rm /var/run/*required*
rm /var/run/init.upgraded

# Unmount stuff
#
umount -lf /proc
umount /sys
umount /dev/pts

