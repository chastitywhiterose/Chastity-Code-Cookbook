#!/bin/sh
cp main.asm main64.asm
#change ELF format and header
sed 's/ELF/ELF64/g' -i main64.asm
sed 's/chastelib32/chastelib64/g' -i main64.asm
#change the registers to 64 bit
sed 's/eax/rax/g' -i main64.asm
sed 's/ebx/rbx/g' -i main64.asm
sed 's/ecx/rcx/g' -i main64.asm
sed 's/edx/rdx/g' -i main64.asm
sed 's/esi/rsi/g' -i main64.asm
sed 's/edi/rdi/g' -i main64.asm
sed 's/ebp/rbp/g' -i main64.asm
#add and subtract 8 from rbp instead of 4
sed 's/add rbp,4/add rbp,8/g' -i main64.asm
sed 's/sub rbp,4/sub rbp,8/g' -i main64.asm
#change exit call at the end of program
sed 's/mov rax,1/mov rax,0x3C/g' -i main64.asm
sed 's/mov rbx,0/mov rdi,0/g' -i main64.asm
sed 's/int 0x80/syscall/g' -i main64.asm
#change dword declarations to qword
sed 's/dword/qword/g' -i main64.asm
sed 's/ dd / dq /g' -i main64.asm
sed 's/ rd / rq /g' -i main64.asm
#assemble the new file
fasm main64.asm
chmod +x main64
./main64
#this script is meant to convert the chastack program from 32 to 64 bits
#note that chastelib64.asm is a header that I manually created
#these sed commands can make most changes but manual review is still required
#system calling conventions are still different between 32 and 64 bits
#and I could have mistakes from things I missed
