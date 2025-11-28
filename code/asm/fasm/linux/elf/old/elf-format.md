# ELF Format

ELF is the Linkable Executable Format. It is the format of executable program used on Linux. For the first time, I am making a serious attempt to learn this format. Here are some links about it.

<https://github.com/xinuos/gabi>

<https://en.wikipedia.org/wiki/Executable_and_Linkable_Format>

<https://flatassembler.net/docs.php?article=manual#2.4>

<https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html>

<https://linux-audit.com/elf-binaries-on-linux-understanding-and-analysis/>



## Why learn this format.

During my time using FASM, I benefited from the fact that FASM can create an executable file without a linker.


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

However, these 52 bytes do not make a value program at all. Here is a complete program that does nothing except exit with a Linux system call.

## Exit Program

```
format ELF executable
mov eax,1 ;function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0 ;return 0 status on exit - 'No Errors'
int 80h   ;call Linux kernel with interrupt
```

When assembling this program, we get a new file that is 96 bytes.

```
./elf-new-exit
00000000 7F 45 4C 46 01 01 01 00 00 00 00 00 00 00 00 00 
00000010 02 00 03 00 01 00 00 00 54 80 04 08 34 00 00 00 
00000020 00 00 00 00 00 00 00 00 34 00 20 00 01 00 28 00 
00000030 00 00 00 00 01 00 00 00 00 00 00 00 00 80 04 08 
00000040 00 80 04 08 60 00 00 00 60 00 00 00 07 00 00 00 
00000050 00 10 00 00 B8 01 00 00 00 BB 00 00 00 00 CD 80 
```

At first glance, it appears to be the same bytes as the 52 byte file with more added. However, by using my program chastecmp, which compares two files until the end is found in either one, we get this

`chastecmp elf-new elf-new-exit`

```
elf-new Opened OK
elf-new-exit Opened OK
00000018 34 54 
0000002C 00 01 
```

These bytes are different. Address 18 contains the length of the header and/or the byte address at which the actual machine instructions start. I don't know what address 2C is without looking up a reference, more on that later.

This information is useful because we can use ndisasm to disassemble the executable, assuming you have it installed. It comes with NASM which is a different assembler.

`ndisasm -b 32 -e 0x54 elf-new-exit`

```
00000000  B801000000        mov eax,0x1
00000005  BB00000000        mov ebx,0x0
0000000A  CD80              int 0x80
```

However, the new program is capable of being executed without error. First we have to give it permissions with the chmod command.

`chmod +x ./elf-new-exit`

At least it will execute without segmentation fault if we run it.

`./elf-new-exit`

But here is a program that actually displays hello world to the terminal before it exits.

## Hello Program

```
format ELF executable

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1 ;function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0 ;return 0 status on exit - 'No Errors'
int 80h   ;call Linux kernel with interrupt

msg db 'Hello World!',0Ah
```

We can assemble, give permissions, and finally execute it with these commands.

```
fasm elf-new-hello.asm
chmod +x elf-new-hello
./elf-new-hello
```

And when we do this, we will get

```
Hello World!
```

However, it is quite sad that we need 131 bytes, most of which is a header just to display a 13 byte message.

`chastehex elf-new-hello`

```
elf-new-hello
00000000 7F 45 4C 46 01 01 01 00 00 00 00 00 00 00 00 00 
00000010 02 00 03 00 01 00 00 00 54 80 04 08 34 00 00 00 
00000020 00 00 00 00 00 00 00 00 34 00 20 00 01 00 28 00 
00000030 00 00 00 00 01 00 00 00 00 00 00 00 00 80 04 08 
00000040 00 80 04 08 83 00 00 00 83 00 00 00 07 00 00 00 
00000050 00 10 00 00 B8 04 00 00 00 BB 01 00 00 00 B9 76 
00000060 80 04 08 BA 0D 00 00 00 CD 80 B8 01 00 00 00 BB 
00000070 00 00 00 00 CD 80 48 65 6C 6C 6F 20 57 6F 72 6C 
00000080 64 21 0A 
```