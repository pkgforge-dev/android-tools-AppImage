#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ! mesa ! vulkan

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

BINARY_SOURCE="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"

mkdir -p ./AppDir/bin ./AppDir/etc/udev/rules.d
wget --retry-connrefused --tries=30 "$BINARY_SOURCE" -O ./bin.zip
unzip ./bin.zip
rm -f ./bin.zip
mv -v  ./platform-tools/* ./AppDir//bin

awk -F"=" '/Revision/{print $2; exit}' ./AppDir/bin/source.properties > ~/version

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
