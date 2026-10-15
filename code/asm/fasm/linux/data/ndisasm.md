Chastity's ndisasm notes.

ndisasm is the Netwide Disassembler. It is installed along with the NASM assembler. It is quite useless for disassembling an entire assembly program because it does not distinguish between code and data. All bytes are assumed to be opcodes for Intel machines. There are 3 modes for operation depending on word size: 16,32,64









ndisasm:
	ndisasm -b 32 -o 0x8048054 -e 0x54 main