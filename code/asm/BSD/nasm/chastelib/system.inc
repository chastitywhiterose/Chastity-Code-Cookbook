;This is the approach we will use throughout this chapter. We will name our include file system.inc, and add to it whenever we deal with a new system call.

;We can start our system.inc by declaring the standard file descriptors:

%define	stdin	0
%define	stdout	1
%define	stderr	2

;Next, we create a symbolic name for each system call:

%define	SYS_nosys	0
%define	SYS_exit	1
%define	SYS_fork	2
%define	SYS_read	3
%define	SYS_write	4
; [etc...]

;We add a short, non-global procedure with a long name, so we do not accidentally reuse the name in our code:

section	.text
align 4
access.the.bsd.kernel:
	int	80h
	ret

;We create a macro which takes one argument, the syscall number:

%macro	system	1
	mov	eax, %1
	call	access.the.bsd.kernel
%endmacro

;Finally, we create macros for each syscall. These macros take no arguments.

%macro	sys.exit	0
	system	SYS_exit
%endmacro

%macro	sys.fork	0
	system	SYS_fork
%endmacro

%macro	sys.read	0
	system	SYS_read
%endmacro

%macro	sys.write	0
	system	SYS_write
%endmacro

