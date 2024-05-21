#!/bin/sh
rm -rf ./.flatpak-builder/ ./build-dir/

DATE=$(date +%Y-%m-%d)
VERSION=$(wget --spider --tries=1 https://mt.lv/winbox64 2>&1 | awk '/winbox64.exe$/ {split($0, a, /winbox/); print gensub(/\//, "", "g", a[2])}')
[ -z "${VERSION}" ] && VERSION="0.0"

cat <<- %E%O%T% >./WinBox.metainfo.xml
<?xml version="1.0" encoding="UTF-8"?>
<component type="desktop-application">
  <id>org.flatpak.WinBox</id>
  <metadata_license>CC0-1.0</metadata_license>
  <project_license>LicenseRef-proprietary</project_license>
  <name>WinBox</name>
  <summary>MikroTik RouterOS administration GUI</summary>
  <developer id="com.mikrotik">
    <name>SIA Mikrotīkls</name>
  </developer>
  <update_contact>hfxdanc_AT_gmail.com</update_contact>

  <description>
	<p>This is a build of WinBox64 for Microsoft Windows, packaged for Linux as a Flatpak using Wine.</p>
	<p><em>NOTE: This wrapper is not verified by, affiliated with, sponsored or supported by MikroTīk in any way.</em></p>
	<p>
	  Winbox is a small utility that allows the administration of MikroTik
	  RouterOS using a fast and simple GUI. It is a native Win32/Win64 binary
	  but can be run on Linux and macOS (OSX) using Wine. All Winbox
	  interface functions are as close as possible mirroring the console
	  functions, that is why there are no Winbox sections in the manual.
	  Some advanced and system critical configurations are not possible from
	  the Winbox, like MAC address change on an interface.
	</p>
  </description>

  <launchable type="desktop-id">org.flatpak.WinBox.desktop</launchable>

  <url type="homepage">https://mikrotik.com</url>
  <url type="help">https://help.mikrotik.com/docs/display/ROS/Winbox</url>

  <screenshots>
	<screenshot type="default">
	  <caption>WinBox Simple loader mode</caption>
	  <image>https://help.mikrotik.com/docs/download/attachments/328129/winbox_loader_simple_.png?version=1&amp;modificationDate=1570715</image>
	</screenshot>
	<screenshot>
	  <caption>Work Area and Child Windows</caption>
	  <image>https://help.mikrotik.com/docs/display/ROS/Winbox?preview=/328129/1409079/winbox3_work_area.png</image>
	</screenshot>
  </screenshots>

  <releases>
	<release version="$VERSION" date="$DATE" />
  </releases>

  <content_rating type="oars-1.1" />
</component>
%E%O%T%

flatpak-builder --default-branch=stable \
--verbose \
--force-clean \
--install-deps-from=flathub \
--install \
--user \
	./build-dir ./org.flatpak.WinBox.yml

# vi: set noexpandtab:wrap:
