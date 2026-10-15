byte.bin is a file containing exactly 256 bytes from 0x00 to 0xFF. It is small enough to be used as an example case for disassembly.

Disassemble in 16 bit mode:

	ndisasm -b 32 byte.bin

Disassemble in 32 bit mode:

	ndisasm -b 32 byte.bin

Disassemble in 64 bit mode:

	ndisasm -b 64 byte.bin
