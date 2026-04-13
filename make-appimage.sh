#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="udev-installer.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=DUMMY
export MAIN_BIN=adb
export APPNAME=Android_Tools

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# add udev rules
UDEV_RULES="https://raw.githubusercontent.com/M0Rf30/android-udev-rules/refs/heads/main/51-android.rules"
wget --retry-connrefused --tries=30 "$UDEV_RULES" -O ./AppDir/etc/udev/rules.d/51-android.rules
sed -i '/cp -v/a	 groupadd -f adbusers; usermod -a -G adbusers $(logname)' ./AppDir/bin/udev-installer.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
