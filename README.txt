NEST live media mastering scripts
=================================

Usage
-----

These scripts are derived from the official Ubuntu wiki page [1], in order to automate the process of live media remastering and minimize the typos and ooopses.

[1]: https://help.ubuntu.com/community/LiveCDCustomization

All scripts are expected to be run as `root` from the folder where they are located, so be extra careful at what you are doing.

   * `10_environment.sh`: contains miscellaneous settings (*do* adjust these to your platform before you start), is not supposed to be run directly, but rather sourced by other scripts.

   * `20_bootstrap_workdir.sh`: creates the working directory for image remastering. Again, be extra careful to not to lose any information.

   * `30_enter_chroot.sh`: takes care of setting up things when you enter and leave the chroot accordingly. Can be either passed a script to run inside the chroot as a parameter, e.g. `50_install_packages.sh` (this script also has to be customized for a particular platform) or run as is and in this case will only open the prompt for you to work it out.

   * `70_master_image.sh`: this script creates an ISO out of the unpacked roots.

Source archives and ISO files have to be downloaded separately.

A typical workflow would involve running the `bootstrap_workdir` script, then `enter_chroot` with `install_packages` as a parameter, then `enter_chroot` alone and finally, when satisfied, `master_image`.

License
-------

Copyright (C) 2011 onwards by Yury V. Zaytsev.

Free to use and distribute under the terms of the MIT License.

