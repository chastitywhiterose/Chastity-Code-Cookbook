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
#change dword declarations to qword
sed 's/ dd / dq /g' -i main64.asm
sed 's/ rd / rq /g' -i main64.asm
#assemble the new file
fasm main64.asm
chmod +x main64
./main64
