# Installing SDL3 on Debian Linux

I downloaded the source code from the release. Version "3.2.20" to be exact.

<https://github.com/libsdl-org/SDL/releases/tag/release-3.2.20>

First, I installed the dependences as outlined in "README-linux.md"

`sudo apt-get install build-essential git make pkg-config cmake ninja-build gnome-desktop-testing libasound2-dev libpulse-dev libaudio-dev libjack-dev libsndio-dev libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxfixes-dev libxi-dev libxss-dev libxkbcommon-dev libdrm-dev libgbm-dev libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdbus-1-dev libibus-1.0-dev libudev-dev`

`sudo apt install libpipewire-0.3-dev libwayland-dev libdecor-0-dev liburing-dev`


The actual commands I used to build and install after reading the documentation in "README-cmake.md".
I changed "/usr/local" to simple "/usr" so that SDL3 would where Debian system expects them to be there.

```
cmake -S . -B build
cmake --build build
sudo cmake --install build --prefix /usr
```

Things were installed correctly and I was able to get a test program working.

I later reread the docs and figured out how to install the documentation and test programs also.

```
cmake -S . -B build -DSDL_INSTALL_DOCS=TRUE -DSDL_TESTS=ON
cmake --build build
sudo cmake --install build --prefix /usr
```

This process of installing from source was necessary because there was not yet a Debian package for SDL3. Now I have matched my Linux SDL3 version with my Linux and Windows computers. Being able to test my programs on both is essential for the programming book I am writing.

