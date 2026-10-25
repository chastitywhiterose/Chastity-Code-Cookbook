# Appendix of System Calls for Linux 32-bit

Although the Linux kernel has hundreds of system calls, every program in my book: Assembly Arithmetic Algorithms for Linux uses only 6 of them. This appendix or reference is designed for quick searching while writing new assembly programs and for deeper understanding about these calls.

For convenience, I have repeated the table from chapter 11 of the 32-bit Linux edition.

|Number|Name |eax |ebx     |ecx   |edx   |
|------|-----|----|--------|------|------|
|1     |exit |0x01|status  |      |      |
|3     |read |0x03|fd      |buf   |count |
|4     |write|0x04|fd      |buf   |count |
|5     |open |0x05|filename|flags |mode  |
|6     |close|0x06|fd      |      |      |
|19    |lseek|0x13|fd      |offset|whence|

## exit

The exit system call must always be the last thing in a program, because what it does is end the program. The most basic possible program which does nothing but exit is as follows:

```
format ELF executable

main:
mov eax,1 ;exit
mov ebx,0 ;return int
int 80h   ;system call
```

The number in ebx is what is returned to the operating system. You can verify it with this command:

```
echo $?
```

The ? variable is a special Linux shell variable that contains the exit status of the last command. Traditionally, 0 means no errors happened. Other numbers are program dependent in their meaning because every program can return any number from 0 to 255.

You may wonder why it is important for a program to return an integer at all. The reason comes back to the Linux Open Source Philosophy. When you download the source code of a program, the archive will usually contain configuration scripts like "configure" that check for the existence of other programs and libraries.

The most logical way to do so is by running those commands and checking the return value with an echo statement as above. Therefore, the return integer is actually super important for programmers to know. You can think of a program as an entire function with a return value passed back to the operating system that called it.