	.file	"hello.c"
	.text
	.section	.rodata
.LC0:
	.string	"Hello, World!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits

movabs $0x40101b,%rax

call   putstring
mov    $0x3c,%eax
mov    $0x0,%edi
syscall

main_string:
	.string	"This program runs in Linux!"

putstring>
push   %rax
push   %rbx
push   %rcx
push   %rdx
mov    %rax,%rbx


putstring_strlen_start>
cmpb   $0x0,(%rbx)
je     401049 <putstring_strlen_end>
inc    %rbx
jmp    40103f <putstring_strlen_start>

putstring_strlen_end:
sub    %rax,%rbx
mov    %rbx,%rdx
mov    %rax,%rsi
mov    $0x1,%edi
mov    $0x1,%eax
syscall
pop    %rdx
pop    %rcx
pop    %rbx
pop    %rax
ret

