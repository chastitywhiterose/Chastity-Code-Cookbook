This folder contains the Linux Intel Assembly Language version of chastelib for the FASM assembler.

The source code is very well documented and I don't need to explain it again here. However, for those unfamiliar with the directives of the Flat Assembler (FASM), I will explain some details specific to this assembler because it is my favorite.

## FASM Assembler Directives

The "format ELF" directive at the top of a source file will cause FASM to assemble the source into an object file.

The "format ELF executable" at the top of a source file tells FASM to create an executable.
When you use this, you may also need to write "entry main" to tell it to start at the main function or whatever label you choose to start your program. I use main because it is name of the function C programs start in. This is just a convention.
However, this feature is the main reason I use FASM. NASM and GAS cannot create executable files without a linker.

For this reason, most of my source code is written for use in FASM but I sometimes port the programs to NASM.