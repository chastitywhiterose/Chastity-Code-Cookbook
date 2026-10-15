;this fasm source file is not the source of a program
;it is a series of data statements designed to build a binary file
;the goal is to generate a listing of nearly every possible
;16 bit Intel x86 opcode and operand

;the motivation is for me to study and reference which assembly instructions
;produce which machine code bytes. This is useful for optimizing 16 bit DOS programs

;opcode 0x00: Add instructions.

db 0,0
db 0,1
db 0,2
db 0,3
db 0,4
db 0,5

;16 bit word operand simulated with two bytes

db 0,6, 0x01,0
db 0,6, 0x02,0
db 0,6, 0x04,0
db 0,6, 0x08,0
db 0,6, 0x10,0
db 0,6, 0x20,0
db 0,6, 0x40,0
db 0,6, 0x80,0

db 0,6, 0,0x01
db 0,6, 0,0x02
db 0,6, 0,0x04
db 0,6, 0,0x08
db 0,6, 0,0x10
db 0,6, 0,0x20
db 0,6, 0,0x40
db 0,6, 0,0x80


db 0,7
db 0,8
db 0,9
db 0,0xA
db 0,0xB
db 0,0xC
db 0,0xD

;16 bit word operand simulated with two bytes

db 0,0xE, 0x01,0
db 0,0xE, 0x02,0
db 0,0xE, 0x04,0
db 0,0xE, 0x08,0
db 0,0xE, 0x10,0
db 0,0xE, 0x20,0
db 0,0xE, 0x40,0
db 0,0xE, 0x80,0

db 0,0xE, 0,0x01
db 0,0xE, 0,0x02
db 0,0xE, 0,0x04
db 0,0xE, 0,0x08
db 0,0xE, 0,0x10
db 0,0xE, 0,0x20
db 0,0xE, 0,0x40
db 0,0xE, 0,0x80
