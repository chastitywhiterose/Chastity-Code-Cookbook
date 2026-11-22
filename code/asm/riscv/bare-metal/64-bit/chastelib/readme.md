By following some tutorials and google searching the errors I was getting, I was able to convert my four functions that were originally written for the RARS RISC-V simulator into a bootloader form that was acceptable to the RISC-V variants of QEMU.

I have written both a 32-bit and 64-bit version of the same program which includes and tests all four functions:

- putstr
- intstr
- putint
- strint

The functions work the same as they do in in my C or Intel Assembly versions. However, the RISC-V architecture was especially challenging because of my lack of experience. Even so, this is an important milestone. I have also provided a makefile with rules for assembling and linking the program using the cross compiling toolchain which I have installed from the Debian repository.
