#!/bin/sh
cp main.asm main.nasm
sed 's/format ELF executable/use32/g' -i main.nasm
sed 's/entry main/jmp main/g' -i main.nasm
sed 's/include/%include/g' -i main.nasm
sed 's/?/0/g' -i main.nasm
nasm main.nasm

#this script converts assembly source for fasm into one that assembles with nasm
#this does not make it a valid program but helps check for syntax portability
#a valid nasm program still requires an elf header created manually or with a linker
#but using this script can be a first step in transforming to a nasm assembly program
#this script is formatter for 32-bit based Linux programs
