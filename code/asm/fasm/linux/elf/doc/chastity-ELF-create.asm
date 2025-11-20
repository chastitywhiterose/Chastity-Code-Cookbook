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
db 1          ;EI_VERSION: 1=EV_CURRENT (ELF identity version 1) (which is current at time of specification Version 4.2 I was using)
db 9 dup 0    ;padding zeros to bring us to address 0x10
dw 2          ;e_type: 2=ET_EXEC (executable instead of object file)
dw 3          ;e_machine : 3=EM_386 (Intel 80386)
dd 1          ;e_version: 1=EV_CURRENT (ELF object file version.)

e_entry=0x8048054 ;we will be reusing this constant later 

dd e_entry    ;e_entry: the virtual address at which the program starts
dd 0x34       ;e_phoff: where in the file the program header offset is
db 8 dup 0    ;e_shoff and e_flags are unused in this example,therefore all zeros
dw 0x34       ;e_ehsize: size of the ELF header
dw 0x20       ;e_phentsize: size of program header which happens after ELF header
dw 1          ;e_phnum: How many program headers. Only 1 in this case
dw 0x28       ;e_shentsize: Size of a section header
dw 0          ;e_shnum number of section headers
dw 0          ;e_shstrndx: section header string index (not used here)

;That is the end of the 0x34 byte (52 bytes decimal) ELF header. Sadly, this is not the end and a program header is also required (what drunk person made this format?)


dd 1           ;p_type: 1=PT_LOAD
dd 0           ;p_offset: Base address from file (zero)
dd 0x8048000   ;p_vaddr: Virtual address in memory where the file will be.
dd 0x8048000   ;p_paddr: Physical address. Same as previous

;not sure about these two values yet

image_size=0x1000 ;Chosen size for file and memory size.

dd image_size       ;Elf32_Word p_filesz: Size of file image of the segment. Must be equal to the file size or greater
dd image_size      ;Elf32_Word p_memsz: This member gives the number of bytes in the memory image of the segment; it may be zero.

dd 7           ;Elf32_Word p_flags; 7=4(Read)+2(Write)+1(Execute)
dd 0x1000      ;Elf32_Word p_align; Alignment

use32 ;tell assembler that 32 bit code is being used
org e_entry ;origin of new code begins at the entry point

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1 ;function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0 ;return 0 status on exit - 'No Errors'
int 80h   ;call Linux kernel with interrupt

msg db 'Hello World!',0Ah

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