#!/bin/bash
#
# This script is to be executed inside the chroot
#
# Copyright (C) 2011 onwards by Yury V. Zaytsev
#
# Free to use and distribute under the terms of the MIT license
#

set -e
set -u

NEST_VERSION="nest-2.0.0-rc4"
PYNN_VERSION="0.7.1"

read -p "
Please uncomment universe / multiverse if needed and add the partner repository:

    deb http://archive.canonical.com/ubuntu SERIES partner
    deb-src http://archive.canonical.com/ubuntu SERIES partner

Now vi will start...
"

vi /etc/apt/sources.list

# Update the system
#
apt-get update
apt-get dist-upgrade

# Actually do install packages
#
apt-get install acroread
apt-get install aptitude
apt-get install emacs emacs-snapshot-gtk
apt-get install flashplugin-installer
apt-get install gedit-plugins
apt-get install inkscape gimp dia
apt-get install mc
apt-get install nautilus-open-terminal
apt-get install network-manager-vpnc-gnome network-manager-pptp-gnome
apt-get install skype
apt-get install ubuntu-restricted-extras ubuntu-restricted-addons
apt-get install vim vim-gnome vim-scripts
apt-get install vlc

apt-get install automake autoconf
apt-get install diff patch
apt-get install git git-svn git-gui git-man gitk
apt-get install libgsl0-dev
apt-get install libmusic-dev
apt-get install libopenmpi-dev
apt-get install libreadline6-dev
apt-get install libtool
apt-get install openmpi-bin
apt-get install python-all-dev
apt-get install python-numpy python-scipy python-matplotlib ipython
apt-get install python-pip
apt-get install subversion

# Better looking gitk (chose wish8.5)
#
apt-get install tk8.5

echo "Please select wish8.5+ as the default..."

update-alternatives --config wish

# NEST
#
cd /usr/src

if [ -f $NEST_VERSION.tar.gz ]; then

    tar -xvzf $NEST_VERSION.tar.gz
    cd $NEST_VERSION

    mkdir build
    cd build

    ../configure \
        --prefix=/opt/nest \
        --with-mpi \
        --with-music

    make -j8
    make install

else
    read -p "$NEST_VERSION.tar.gz not found, skipping! Press Enter to continue..."
fi

# PyNN
#
cd /usr/src

svn co https://neuralensemble.org/svn/PyNN/tags/$PYNN_VERSION pyNN-$PYNN_VERSION
cd pyNN-$PYNN_VERSION
python setup.py install

# NeuroTools
#
cd /usr/src

svn co https://neuralensemble.org/svn/NeuroTools/trunk NeuroTools
cd NeuroTools
python setup.py install

read -p "Now please set desired environment variables, e.g.:

    # ZYV
    PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/nest/bin\"
    PYTHONPATH=\"/opt/nest/lib/python2.7/site-packages:\$PYTHONPATH\"

vim will now start...
"

vim /etc/environment

echo "Finished!"

