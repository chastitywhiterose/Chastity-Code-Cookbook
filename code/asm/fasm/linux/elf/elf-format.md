ELF Format

ELF is the Linkable Executable Format. It is the format of executable program used on Linux. For the first time, I am making a serious attempt to learn this format. Here are some links about it.

https://flatassembler.net/docs.php?article=manual#2.4

## Why learn this format.

During my time using FASM, I benefitted from the fact that FASM can create an executable file without a linker.


For example, when I create a file named elf-new.asm that contains only the line

```
format ELF executable
```

I can assembly it with `fasm elf-new.asm`

A 52 byte file will be created. Using my chastehex program I created in Assembly, I can quickly get a hex dump of this file.

```
chastehex ./elf-new
./elf-new
00000000 7F 45 4C 46 01 01 01 00 00 00 00 00 00 00 00 00 
00000010 02 00 03 00 01 00 00 00 34 80 04 08 34 00 00 00 
00000020 00 00 00 00 00 00 00 00 34 00 20 00 00 00 28 00 
00000030 00 00 00 00 
```

other ways of obtaining a hex dump work such as

- hd ./elf-new
- hexdump -C ./elf-new
- xxd -g1 ./elf-new



chmod +x ./elf-new