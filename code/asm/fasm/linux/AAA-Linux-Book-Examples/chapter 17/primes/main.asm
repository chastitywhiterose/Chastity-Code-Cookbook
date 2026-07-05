format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

;the only even prime is 2
mov eax,2
call putint
call putspace

;fill array with zeros up to length
mov ebx,0
array_zero:
mov [array+ebx],0
inc ebx
cmp ebx,length
jb array_zero

;start by filtering multiples of first odd prime: 3
mov eax,3

primes:

;print this number because it is prime
call putint
call putspace

mov ebx,eax ;mov eax to ebx as our array index variable
mov ecx,eax ;mov eax to ecx
add ecx,ecx ;add ecx to itself

sieve:
mov [array+ebx],1 ;mark element as multiple of prime
add ebx,ecx ;check only multiples of this prime times 2 to exclude even numbers
cmp ebx,length
jb sieve

;check odd numbers until we find unused one not marked as multiple of prime
mov ebx,eax
next_odd:
add ebx,2
cmp [array+ebx],0
jz prime_found
cmp ebx,length
jb next_odd
prime_found:

;get next prime ready to print in eax
mov eax,ebx
cmp eax,length
jb primes
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'

length=1000
array rb length


