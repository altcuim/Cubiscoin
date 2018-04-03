
Debian
====================
This directory contains files used to package cubisd/cubis-qt
for Debian-based Linux systems. If you compile cubisd/cubis-qt yourself, there are some useful files here.

## cubis: URI support ##


cubis-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install cubis-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your cubisqt binary to `/usr/bin`
and the `../../share/pixmaps/cubis128.png` to `/usr/share/pixmaps`

cubis-qt.protocol (KDE)

