# Installing SDL2 on Debian Linux

The commands I used to install SDL version 2.32.8 from the source archive on my Debian Linux system.

./configure --prefix=/usr
make
sudo make install

---

Sources I read

 Linux and other UNIX systems:
        * Run './configure; make; make install'

https://wiki.libsdl.org/SDL2/Installation

---

At first I forgot to specify the /usr prefix. I messed up my system and nothing was compiling because the default /usr/local was where the new install was whereas all the other libraries were installed in subdirectories of /usr.

Therefore I had to repead the command and then remove the sdl2-config file from the /usr/local/bin directory.

Then everything compiled as before, even my Tetris game and my new LGBT font library.

Technically I did not need the latest SDL2 version available but I wanted to learn how to install updates from source rather than only relying on the Debian repositories.

This is because I am considering making my own Linux distribution.