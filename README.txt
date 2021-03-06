NEST live media mastering scripts
=================================

Usage
-----

These scripts are derived from the official Ubuntu wiki page [1], in order to automate the process of live media remastering and minimize the typos and ooopses.

[1]: https://help.ubuntu.com/community/LiveCDCustomization

All scripts are expected to be run as `root` from the folder where they are located, so be extra careful at what you are doing.

* `10_environment.sh`: contains miscellaneous settings (*do* adjust these to your platform before you start), is not supposed to be run directly, but rather sourced by other scripts.

* `20_bootstrap_workdir.sh`: creates the working directory for image remastering. Again, be extra careful to not to loose any information.

* `30_enter_chroot.sh`: takes care of setting up things when you enter and leave the chroot accordingly. Can be either passed a script to run inside the chroot as a parameter, e.g. `50_install_packages.sh` (this script also has to be customized for a particular platform) or run as is and in this case will only open the prompt for you to work it out.

* `70_master_image.sh`: this script creates an ISO out of the unpacked roots.

Source archives and ISO files have to be downloaded separately.

A typical workflow would involve running the `bootstrap_workdir` script, then `enter_chroot` with `install_packages` as a parameter, then `enter_chroot` alone and finally, when satisfied, `master_image`.

/!\ After initial bootstrapping of the chroot, do a dist-upgrade, but beware upgrading kernel packages! This stuff can cause substantial breakage! For instance, many kernel modules might not work anymore. If you want to upgrade to the next point release, just re-bootstrap the whole thing instead.

To make sure apt-get doesn't upgrade the packages, put them on hold this way:

    echo linux-firmware hold | dpkg --set-selections
    echo linux-generic-pae hold | dpkg --set-selections
    echo linux-image-generic-pae hold | dpkg --set-selections
    echo linux-headers-generic-pae hold | dpkg --set-selections

/!\ You might wish to remove BLCR, pulled in by OpenMPI, since it's know to break upgrades:

    apt-get remove --purge blcr-dkms

/!\ To remove the choice to install Ubuntu on bootup:

a) Proper way: rebuild gfxboot-theme-ubuntu with gfxboot-theme-ubuntu-no-ubiquity.patch, take bootlogo out and then put it into /isolinux.
b) Hacky way: open /isolinux/bootlogo in a hex editor, change "maybe-ubiquity" to spaces (0x20) and then read a prayer.

Of course, given a choice one would go the hacky way.

/!\ To create a virtual machine image:

a) Mount a drive in a virtual machine
b) Boot from the LiveCD
c) Run usb-creator-gtk --allow-system-internal

Now it should allow you to use the virtual disk as an USB stick. Finally, install VirtualBox guest additions FTW.

/!\ After the VirtualBox guest additions are installed, make sure to add 'ubuntu' to the 'vboxsf' group, so that the users can access shared folders through /media/sf_xxx:

    sudo usermod -a -G vboxsf ubuntu

CNS Tutorials
-------------

Update both:

* extract-cd/cns-2011-tutorials
* squashfs-root/usr/share/example-content/cns-2011-tutorials

Modify (files with other filenames won't be copied to the desktop, but rather stay in $HOME):

* /etc/skel/examples.desktop

(see example.desktop)

Desktop background
------------------

Options:

    gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /desktop/gnome/background/picture_options "scaled"

Otherwise, the image has to be prepared in a way that it would be cropped nicely by the `zoom` algorithm on both anamorphic and non-anamorphic screens.

Files:

    /usr/share/backgrounds/warty-final-ubuntu.png

(needs to be replaced with custom image)

License
-------

Copyright (C) 2011 onwards by Yury V. Zaytsev.

Free to use and distribute under the terms of the MIT License.

