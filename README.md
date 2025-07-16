# android-tools-AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/pkgforge-dev/android-tools-AppImage/total?logo=github&label=GitHub%20Downloads)](https://github.com/pkgforge-dev/android-tools-AppImage/releases/latest)
[![CI Build Status](https://github.com//pkgforge-dev/android-tools-AppImage/actions/workflows/blank.yml/badge.svg)](https://github.com/pkgforge-dev/android-tools-AppImage/releases/latest)

* [Latest Stable Release](https://github.com/pkgforge-dev/android-tools-AppImage/releases/latest)

---

Unofficial AppImage of Android Platform Tools (adb, fastboot, etc), uses the official [binaries](https://developer.android.com/tools/releases/platform-tools) and turns them into an AppImage.

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.**

AppImage made using [sharun](https://github.com/VHSgunzo/sharun), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks.

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.**

It is possible that this appimage may fail to work with appimagelauncher, I recommend these alternatives instead: 

* [AM](https://github.com/ivan-hc/AM) `am -i android-tools` or `appman -i android-tools`

* [dbin](https://github.com/xplshn/dbin) `dbin install android-tools.appimage`

* [soar](https://github.com/pkgforge/soar) `soar install android-tools`

This appimage works without fuse2 as it can use fuse3 instead, it can also work without fuse at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
  </a>
</details>
