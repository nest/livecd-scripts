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

NEST_VERSION="nest-2.1.9349-pre"
NEURON_VERSION="neuron-7.1-0ubuntu1_python27_natty11.04_i386.deb"

NEST_VERSION=""
NEURON_VERSION=""

NEURODEBIAN_FLAVOR="precise"

INSTALL_TEXLIVE="no"
INSTALL_JAVA="no"
INSTALL_STEPS="no"

read -p "
Please uncomment universe / multiverse if needed and add the partner repository:

    deb http://archive.canonical.com/ubuntu SERIES partner
    deb-src http://archive.canonical.com/ubuntu SERIES partner

Now vi will start...
"

vi /etc/apt/sources.list

# Install NeuroDebian repositories
#
wget -O- http://neuro.debian.net/lists/$NEURODEBIAN_FLAVOR.us-nh | tee /etc/apt/sources.list.d/neurodebian.sources.list
apt-key adv --recv-keys --keyserver pgp.mit.edu 2649A5A9

# Disable popularity contest for clones
#
read -p "Please answer NO to the next question, OK?"
dpkg-reconfigure popularity-contest

# Update the system
#
apt-get clean
apt-get update
apt-get dist-upgrade

# Actually do install packages
#
apt-get install acroread
apt-get install flashplugin-installer
apt-get install skype
apt-get install ubuntu-restricted-extras ubuntu-restricted-addons

apt-get install aptitude
apt-get install gedit-plugins
apt-get install inkscape gimp dia
apt-get install mc
apt-get install nautilus-open-terminal
apt-get install network-manager-vpnc-gnome network-manager-pptp-gnome
apt-get install vim vim-gnome vim-scripts
apt-get install vlc

apt-get install build-essential
apt-get install automake autoconf
apt-get install diff patch
apt-get install git git-svn git-gui git-man gitk
apt-get install libgsl0-dev
apt-get install libmusic-dev
apt-get install libopenmpi-dev
apt-get install libreadline-dev
apt-get install libtool
apt-get install openmpi-bin
apt-get install python-all-dev
apt-get install python-numpy python-scipy python-matplotlib ipython cython
apt-get install python-pip
apt-get install subversion

apt-get install diveintopython diveintopython-zh

# Install emacs manually, because Ubuntu no longer provides emacs-snapshot and so doesn't have a GTK version
#
# PPA with packages for download is here: https://launchpad.net/~cassou/+archive/emacs/+packages
#

# Better looking gitk (chose wish8.5)
#
apt-get install tk8.5
echo "Please select wish8.5+ as the default..."
update-alternatives --config wish

# Set Sun Java as a default JRE / JDK
#
if test "x$INSTALL_JAVA" = "xyes"; then
    apt-get install sun-java6-jre sun-java6-jdk sun-java6-plugin sun-java6-fonts
    update-java-alternatives -s java-6-sun
fi

# Full TeX authoring environment
#
if test "x$INSTALL_TEXLIVE" = "xyes"; then
    apt-get install texlive
    apt-get install texworks texworks-scripting-lua texworks-scripting-python
    apt-get install lyx
fi

# Mayavi2 and the Python bindings
#
apt-get install mayavi2

# This all comes from NeuroDebian (or it used to be the case)

# mpi4py
#
apt-get install python-mpi4py

# PyNN
#
apt-get install python-pynn

# xppaut
#
apt-get install xppaut

# STEPS - http://steps.sourceforge.net/STEPS/Download.html
#
apt-get install python-opengl
apt-get install python-wxgtk2.8

if test "x$INSTALL_STEPS" = "xyes"; then
    easy_install steps
fi

# SWIG is only necessary to re-generate the wrappers, normally should work without it
# apt-get install swig

# Neuron
# For packages, see: http://neuralensemble.org/people/eilifmuller/Software.html

if [ -n "$NEURON_VERSION" ]; then
    dpkg -i /usr/src/$NEURON_VERSION
    apt-get install -f
fi

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

# NeuroTools
#
cd /usr/src

svn co https://neuralensemble.org/svn/NeuroTools/trunk NeuroTools
cd NeuroTools
python setup.py install

read -p "Now please set desired environment variables, e.g.:

    # ZYV
    PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/nest/bin:/opt/nrn/i686/bin\"
    PYTHONPATH=\"/opt/nest/lib/python2.7/site-packages:/usr/local/lib/python2.7/dist-packages\"

vim will now start...
"

vim /etc/environment

echo "Finished!"

