# Appendix of System Calls for Linux 32-bit Intel Assembly Language

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

Parameters:

- eax = 1
- ebx = return integer

Returns:

The exit system call must always be the last thing in a program, because what it does is end the program. The most basic possible program which does nothing but exit is as follows:

Example:

```
format ELF executable

main:
mov eax,1 ;exit (kernel opcode 1)
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

## read

Parameters:

- eax = 3
- ebx = file descriptor
- ecx = buffer address
- edx = how many bytes to read

Returns:

eax = how many bytes were read

## write

Parameters:

- eax = 4
- ebx = file descriptor
- ecx = buffer address
- edx = how many bytes to write

Returns:

eax = how many bytes were written

Example:

```
format ELF executable

main:
mov eax,4   ; invoke SYS_WRITE (kernel opcode 4)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1   ; function SYS_EXIT (kernel opcode 1)
mov ebx,0   ; return 0 status on exit - 'No Errors'
int 80h

msg db 'Hello World!',0Ah,0
```

## open

Parameters:

- eax = 5
- ebx = pointer to filename string
- ecx = flags to control how file is opened
- edx = file permissions in the case of new file

Returns:

eax = file descriptor if opening was successful
-1 if an error happened

### Open Flags values

|name    |int (octal)|
|--------|-----------|
|O_RDONLY|  00|
|O_WRONLY|  01|
|O_RDWR  |  02|
|O_CREAT |0100|

The fourth argument to the open call, passed in the edx register, is only used in the case of opening a new file. A good example of this is in chapter 7 of Assembly Arithmetic Algorithms 32-bit Linux which contains an example of creating a new file and also an example of opening a file that already exists, in which case edx is irrelevant for the open call.

## close

Parameters:

- eax = 6
- ebx = file descriptor

Returns:

eax = 0 if closing was successful
-1 if an error happened

## lseek

Parameters:

- eax = 19
- ebx = file descriptor
- ecx = offset
- edx = whence (see notes below)

Returns:

eax = offset from beginning of file
-1 if an error happened

### Whence Values

|name    |int|meaning|
|--------|---|-------|
|SEEK_SET|0  |Seek from beginning of file.|
|SEEK_CUR|1  |Seek from current position.|
|SEEK_END|2  |Seek from end of file.|
