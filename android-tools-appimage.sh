#!/bin/sh

set -eux

ARCH="$(uname -m)"
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"
BINARY="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
UDEV="https://raw.githubusercontent.com/M0Rf30/android-udev-rules/refs/heads/main/51-android.rules"

export ADD_HOOKS="udev-installer.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export URUNTIME_PRELOAD=1 # really needed here

# CREATE DIRECTORIES AND DOWNLOAD THE ARCHIVE
mkdir -p ./AppDir/shared/bin ./AppDir/bin ./AppDir/etc/udev/rules.d
wget --retry-connrefused --tries=30 "$BINARY" -O ./bin.zip
unzip -q ./bin.zip
rm -f ./bin.zip
cp -v  ./platform-tools/mke2fs.conf ./AppDir/bin
mv -v  ./platform-tools/*           ./AppDir/shared/bin

VERSION="$(awk -F"=" '/Revision/{print $2; exit}' ./AppDir/shared/bin/source.properties)"
[ -n "$VERSION" ] && echo "$VERSION" > ~/version
export OUTNAME=Android_Tools-"$VERSION"-anylinux-"$ARCH".AppImage

# add udev rules
wget --retry-connrefused --tries=30 "$UDEV" -O ./AppDir/etc/udev/rules.d/51-android.rules

# DEPLOY ALL LIBS
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun ./AppDir/shared/bin/*

# We also need to be added to a group after installing udev rules
sed -i '/cp -v/a	 groupadd -f adbusers; usermod -a -G adbusers $(logname)' ./AppDir/bin/udev-installer.hook

# MAKE APPIMAGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage

UPINFO="$(echo "$UPINFO" | sed 's#.AppImage.zsync#*.AppBundle.zsync#g')"
wget -O ./pelf "https://github.com/xplshn/pelf/releases/latest/download/pelf_$ARCH"
chmod +x ./pelf
echo "Generating [dwfs]AppBundle..."
./pelf \
	--add-appdir ./AppDir                     \
	--appimage-compat                         \
	--disable-use-random-workdir              \
	--add-updinfo "$UPINFO"                   \
	--compression "-C zstd:level=22 -S26 -B8" \
	--appbundle-id="android-tools#github.com/$GITHUB_REPOSITORY:$VERSION@$(date +%d_%m_%Y)" \
	--output-to ./Android_Tools-"$VERSION"-anylinux-"$ARCH".dwfs.AppBundle

echo "Generating zsync file..."
zsyncmake ./*.AppBundle -u ./*.AppBundle

echo "All Done!"
