format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

;the only even prime is 2
mov rax,2
call putint
call putspace

;fill array with zeros up to length
mov rbx,0
array_zero:
mov [array+rbx],0
inc rbx
cmp rbx,length
jb array_zero

;start by filtering multiples of first odd prime: 3
mov rax,3

primes:

;print this number because it is prime
call putint
call putspace

mov rbx,rax ;mov rax to rbx as our array index variable
mov rcx,rax ;mov rax to rcx
add rcx,rcx ;add rcx to itself

sieve:
mov [array+rbx],1 ;mark element as multiple of prime
add rbx,rcx ;check only multiples of this prime times 2 to exclude even numbers
cmp rbx,length
jb sieve

;check odd numbers until we find unused one not marked as multiple of prime
mov rbx,rax
next_odd:
add rbx,2
cmp [array+rbx],0
jz prime_found
cmp rbx,length
jb next_odd
prime_found:

;get next prime ready to print in eax
mov rax,rbx
cmp rax,length
jb primes
call putline

sub rsp,40
mov rcx,0
call [ExitProcess]

length=1000
array rb length

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
