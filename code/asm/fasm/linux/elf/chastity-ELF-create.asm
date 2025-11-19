;Chastity's Source for ELF file creation
;
;All data as defined in this file is basd off of the specification of the ELF file format.
;I first looked at the type of file created by FASM's "format ELF executable" directive.
;It is great that FASM can create an executable file automatically.
;However, I wanted to understand the format for use in other assemblers like NASM.

;The Github repository with the spec I used is here.
;<https://github.com/xinuos/gabi>
;And this is the wikipedia article which linked me to the specification document
;<https://en.wikipedia.org/wiki/Executable_and_Linkable_Format>

;For the purposes of this file, it is not meant to be included in actual projects because my example sections are meant to be copy pasted for which type of ELF executable on an Intel machine running Linux you are trying to make.

;Example of defining 32 bit ELF executable

db 0x7F,"ELF" ;ELFMAGIC: 4 bytes that identify this as an ELF file. The magic numbers you could say.
db 1          ;EI_CLASS: 1=32-bit 2=64-bit
db 1          ;EI_DATA: The endianness of the data. 1=ELFDATA2LSB 2=ELFDATA2MSB For Intel x86 this is always 1 as far as I know.
db 1          ;EV_CURRENT: ELF version 1 (which is current at time of specification Version 4.2 I was using)
db 9 dup 0    ;padding zeros to bring us to address 0x10


;chastity@chastity-um250:~/git/Chastity-Code-Cookbook/code/asm/fasm/linux/elf$ hd ./elf-new-hello
;00000000  7f 45 4c 46 01 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
;00000010  02 00 03 00 01 00 00 00  54 80 04 08 34 00 00 00  |........T...4...|
;00000020  00 00 00 00 00 00 00 00  34 00 20 00 01 00 28 00  |........4. ...(.|
;00000030  00 00 00 00 01 00 00 00  00 00 00 00 00 80 04 08  |................|
;00000040  00 80 04 08 83 00 00 00  83 00 00 00 07 00 00 00  |................|
;00000050  00 10 00 00 b8 04 00 00  00 bb 01 00 00 00 b9 76  |...............v|
;00000060  80 04 08 ba 0d 00 00 00  cd 80 b8 01 00 00 00 bb  |................|
;00000070  00 00 00 00 cd 80 48 65  6c 6c 6f 20 57 6f 72 6c  |......Hello Worl|
;00000080  64 21 0a                                          |d!.|
;00000083



;fasm chastity-ELF-create.asm
;hd chastity-ELF-create.bin