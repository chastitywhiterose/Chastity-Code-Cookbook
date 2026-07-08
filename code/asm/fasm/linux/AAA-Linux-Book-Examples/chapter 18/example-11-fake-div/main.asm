format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,256
mov esi,10

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_div:
;save registers used in the long division algorithm
push eax
push ebx
push ecx
mov eax,0
mov ebx,0
mov ecx,1
cmp esi,0
jz fake_div_sub_loop_end ;div by 0 invalid
fake_div_sub_loop:
cmp ecx,0
jz fake_div_sub_loop_end
shl eax,1
shl ebx,1
test edi,edi ;test edi with itself to check sign bit
jns skip_or  ;skip copy of sign bit if it was 0
or ebx,1     ;store a 1 in low bit of ebx based on sign
skip_or:
shl edi,1

;skip subtraction if ebx is below esi
cmp ebx,esi
jb skip_sub 
sub ebx,esi
or eax,1
skip_sub:

shl ecx,1
jmp fake_div_sub_loop
fake_div_sub_loop_end:

;send results to correct registers and clean up
mov edi,eax ;copy quotient to edi
mov esi,ebx ;copy remainder to esi
;restore registers to their original values
pop ecx
pop ebx
pop eax

mov eax,edi
call putint
call putline

mov eax,esi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
