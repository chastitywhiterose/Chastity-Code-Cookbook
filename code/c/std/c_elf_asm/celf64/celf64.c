/*
 This C program creates an ELF executable file identical to one that
 would be assembled by FASM. The purpose was to learn the ELF64 format.
 
 The Github repository with the spec I used is here.
 <https://github.com/xinuos/gabi>

 And this is the wikipedia article which linked me to the specification document
 <https://en.wikipedia.org/wiki/Executable_and_Linkable_Format>
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "elf.h"

int main(int argc, char *argv[])
{
 int x;
 char *p;
 FILE* fp; /*file pointer*/
 Elf64_Ehdr header; /*elf header structure*/
 Elf64_Phdr program; /*program header that follows the regular elf header*/
 
 /*
 This is the actual machine code originally assembled by FASM.
 In the comments, I show the original assembly source code.
 The number loaded in the rdx register is the number of bytes to write.
 In this example, it is hex D or 13 decimal (try changing it for fun)
 starting at the address loaded in ecx
 rdi is set to 1 because it is the standard output
 rax is set to 1 because that is the number to call the write function in the 64 bit Linux kernel
 syscall is a new instruction for how the Linux kernel is called.
 */
 unsigned char code[]=
 {
  0x48,0xC7,0xC0,0x01,0x00,0x00,0x00, /* mov rax,0x1       */
  0x48,0xC7,0xC7,0x01,0x00,0x00,0x00, /* mov rdi,0x1       */
  0x48,0xC7,0xC6,0xA6,0x00,0x40,0x00, /* mov rsi,0x4000a6  */
  0x48,0xC7,0xC2,0x0D,0x00,0x00,0x00, /* mov rdx,0xd       */
  0x0F,0x05,                          /* syscall           */
  0x48,0xC7,0xC0,0x3C,0x00,0x00,0x00, /* mov rax,0x3c      */
  0x48,0xC7,0xC7,0x00,0x00,0x00,0x00, /* mov rdi,0x0       */
  0x0F,0x05,                          /* syscall           */
 };

 char data[]="Hello World!\n"; 

 /*
  use a pointer to zero all the bytes of the header to question marks
  this is how I know which I have filled and which still need to be filled
 */
 p=(char*)&header;
 x=0;
 while(x<sizeof(header))
 {
  *p=0;
  p++;
  x++;
 }

 /*The first four bytes tell the OS that this is an ELF file*/

 header.e_ident[0]=0x7F;
 header.e_ident[1]='E';
 header.e_ident[2]='L';
 header.e_ident[3]='F';

 /*
  the next byte sets whether this is 32 or 64 bits
  1=32 bits
  2=64 bits
 */
 header.e_ident[4]=2;

 /*
  The next byte defines whether the encoding byte order is little or big endian.
  ELFDATA2LSB 1 (little endian like used on all Intel CPUs)
  ELFDATA2MSB 2 (big endian where the largest bit place values come first in the file)
 */
 header.e_ident[5]=1;

 /*version 1 of the ELF header*/
 header.e_ident[6]=1;

 /*
  an elf type of 2 means executable file
  this is more useful than an object file only used for linking
 */
 header.e_type=2;

 /*
  the machine type means which CPU code we are trying to run
  the full list of possible machines is very long but I will list my favorites

  3 Intel 80386 (32 bit Intel machines)
  62 AMD x86-64 architecture (modern Intel based machines)
  243 RISC-V (the popular open source specification for RISC machines)
 */
 header.e_machine=0x3E;

 /*version 1 of the elf header*/
 header.e_version=1;

 /*address where the program will begin executing code*/
 header.e_entry=0x400078;

 /*
  the file offset where the program header begins
  this is a separate header from the ELF header.
  We place it at hex 0x40 because that is directly after this ELF header
 */
 header.e_phoff=0x40;

 /*the size of the ELF header*/
 header.e_ehsize=0x40;

 /*size that the program header will be*/
 header.e_phentsize=0x38;

 /*there is only 1 program header in this file*/
 header.e_phnum=1;

 /*
  section header size
  I set this value to 0x40 to be consistent with what FASM produces,
  but I don't believe it is actually used in this example
 */
 header.e_shentsize=0x40;
 
 /*next we set the values for the program header*/
 
 /*a program type of 1 means PT_LOAD which loads the bytes into memory for execution*/
 program.p_type=1;
 
 program.p_offset=0;
 program.p_vaddr=header.e_entry-0x78;
 program.p_paddr=program.p_vaddr;
 
 /*
  normally the file size and the memory size are the same
  To calculate how big the file will be, I perform some math
  the combined size of the ELF header,program header, code, and data
  can be known by the C sizeof operator on each of them.
 */
  
 program.p_filesz=sizeof(header)+sizeof(program)+sizeof(code)+sizeof(data);
 program.p_memsz=program.p_filesz;
 
 /*
  permission flags for the segment

  Name Value Meaning
  PF_X 0x1 Execute
  PF_W 0x2 Write
  PF_R 0x4 Read
  
  The value of 7 means all permissions because 1+2+4==7
 */
 program.p_flags=7;
 
 /*
 this is the alignment chosen when FASM creates executables.
 In this case, it means each segment is loaded on a multiple of
 4 kilobytes=4096 decimal or 0x1000 hex
 the p_vaddr and p_paddr variables must be set to a multiple of this value
 Since I used the default values that FASM did, everything is aligned perfectly
 */
 program.p_align=0x1000; 

 fp=fopen("casmelf64","wb");
 if(fp==NULL)
 {
  printf("File \"%s\" cannot be opened.\n",argv[1]);
  return 1;
 }

 printf("Writing ELF header at address %lX\n",ftell(fp));
 /*write the header structure with one fwrite command*/
 fwrite(&header,sizeof(header),1,fp);
 
 printf("Writing program header at address %lX\n",ftell(fp));
 /*write the program header structure with one fwrite command*/
 fwrite(&program,sizeof(program),1,fp);
 
 printf("Writing machine code at address %lX\n",ftell(fp));
 /*
  now that both headers are complete,
  write the code section right after them
 */
  fwrite(&code,sizeof(code),1,fp);

 printf("Writing printable string at address %lX\n",ftell(fp));
 /*write the string which is meant to be printed by the final executable*/
 fwrite(&data,sizeof(data),1,fp);

 printf("Linux 64-bit AMD x86-64 executable created of size %lX\n",ftell(fp));

 fclose(fp);
     
 return 0;
}

/*
The following is the original reference program written in FASM.
FASM's ability to generate executables natively was very helpful
in learning to generate it with this C program.

---

format ELF64 executable

mov rax,1   ; invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
mov rdi,1   ; write to the STDOUT file
mov rsi,msg ; pointer/address of string to write
mov rdx,13  ; number of bytes to write
syscall

mov rax,60  ; function SYS_EXIT (kernel opcode 60 on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

msg db 'Hello World!',0Ah,0

---

The following is the output of:
"ndisasm -b 64 -o 0x400078 -e 0x78 casmelf64"

---

00400078  48C7C001000000    mov rax,0x1
0040007F  48C7C701000000    mov rdi,0x1
00400086  48C7C6A6004000    mov rsi,0x4000a6
0040008D  48C7C20D000000    mov rdx,0xd
00400094  0F05              syscall
00400096  48C7C03C000000    mov rax,0x3c
0040009D  48C7C700000000    mov rdi,0x0
004000A4  0F05              syscall

---

Because that command skips the header and tells it that it contains 32 bit code.
After the second syscall, ndisasm will start printing junk data
because it thinks the text string is code.
*/

