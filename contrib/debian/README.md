
Debian
====================
This directory contains files used to package dogcashd/dogcash-qt
for Debian-based Linux systems. If you compile dogcashd/dogcash-qt yourself, there are some useful files here.

## dogcash: URI support ##


dogcash-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install dogcash-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your dogcash-qt binary to `/usr/bin`
and the `../../share/pixmaps/dogcash128.png` to `/usr/share/pixmaps`

dogcash-qt.protocol (KDE)

