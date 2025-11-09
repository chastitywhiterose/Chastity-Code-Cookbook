# Assembly Language References

<https://wiki.gentoo.org/wiki/Assembly_Language#x86>

<https://en.wikibooks.org/wiki/X86_Assembly>

<https://asmtutor.com/>

<https://github.com/mschwartz/assembly-tutorial>

<https://www.randallhyde.com/AssemblyLanguage/LinuxAsm/index.html>

<https://en.wikibooks.org/wiki/X86_Assembly/Interfacing_with_Linux>

<https://jameshfisher.com/2018/03/10/linux-assembly-hello-world/>

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
<https://www.cs.cmu.edu/~ralf/files.html>

DOS DPMI extender

https://sandmann.dotster.com/cwsdpmi/

Directions for use (server can be used in either of two different ways):

1) "cwsdpmi" alone with no parameters will terminate and stay resident FOR A SINGLE DPMI PROCESS. This means it unloads itself when your DPMI application exits. This mode is useful in software which needs DPMI services, since CWSDPMI can be exec'ed and then will unload on exit.

2) "cwsdpmi -p" will terminate and stay resident until you remove it. It can be loaded into UMBs with LH. "cwsdpmi -u" will unload the TSR.


Most Relevant Lessons of asmtutor

https://asmtutor.com/#lesson2
https://asmtutor.com/#lesson8
https://asmtutor.com/#lesson24


# Useful commands from fasm users

sed '/NR/!d;s/#define[^a-z]*//;s/^/sys_/;s/ / = /' /usr/include/asm/unistd_32.h | wc -l

sed '/NR/!d;s/#define[^a-z]*//;s/^/sys_/;s/ / = /' /usr/include/x86_64-linux-gnu/asm/unistd_32.h | wc -l


# Linux Syscalls

<https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit>  

<https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86_64-64-bit>  

<https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/errnos/>