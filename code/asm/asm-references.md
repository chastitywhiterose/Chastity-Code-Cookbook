# Assembly Language References

<https://wiki.gentoo.org/wiki/Assembly_Language#x86>

<https://en.wikibooks.org/wiki/X86_Assembly>

<https://asmtutor.com/>

<https://github.com/mschwartz/assembly-tutorial>

<https://www.randallhyde.com/AssemblyLanguage/LinuxAsm/index.html>

<https://en.wikibooks.org/wiki/X86_Assembly/Interfacing_with_Linux>

Assembly language is a lot harder to find information on than C or C++. However, it is possible to write useful programs under Linux using assembly and calling the Linux kernel through interrupts.

Local Documentation on Debian

/usr/share/doc/fasm/
/usr/share/doc/nasm/

## Has the Linux system call numbers for eax register.

/usr/include/x86_64-linux-gnu/asm/unistd_32.h

Order of registers for system calls is:

register mapping for system call invocation using int 0x80

| system call number | 1st | 2nd | 3rd |	4th | 5th | 6th | result |
|---|---|---|---|---|---|---|---|
|eax|ebx|ecx|edx|esi|edi|ebp|	eax|

# DOS Information

<https://cable.ayra.ch/md/hello-world-in-dos>
