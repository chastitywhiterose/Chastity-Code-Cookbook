.data

string0: .asciz "Hello World!\n"

.text

li a0, 1       # STDOUT file number
la a1, string0 # address of string 
li a2, 13      # length of string
li a7, 64      # write call number
ecall          # environment call

li a0, 0       # status
li a7, 93      # exit
ecall          # environment call
