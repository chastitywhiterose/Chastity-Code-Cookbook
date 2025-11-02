Chastity Windows Reverse Engineering Notes

The Windows version of FASM includes header files for the Windows API. It also includes some examples, but not a single one of them were a simple "Hello World" console program.

Fortunately, I was able to find one that actually assembled and ran on the FASM forum. To get it working required me to keep the include files and set the include environment variable.

set include=C:\fasm\INCLUDE

However, the problem is much worse than that. The example that I found online and got working uses macros, most specifically, one called "invoke". While this works if you include the headers, it hides the details of what is actually happening. Therefore, I decided to reverse engineer the process by using NOP instructions to sandwich the bytes of machine code.

90 hex is the byte for NOP (No OPeration). So to extract the macro call that exits the program, I use this.

```
db 10h dup 90h
invoke  ExitProcess,0
db 10h dup 90h
```

Then I disassemble the executable and find the actual instructions given.

`ndisasm main.exe -b 32 > disasm.txt`

As simple as this method is, it actually works. For example, this output is given.

```
0000022D  90                nop
0000022E  90                nop
0000022F  90                nop
00000230  90                nop
00000231  90                nop
00000232  90                nop
00000233  90                nop
00000234  90                nop
00000235  90                nop
00000236  90                nop
00000237  90                nop
00000238  90                nop
00000239  90                nop
0000023A  90                nop
0000023B  90                nop
0000023C  90                nop
0000023D  6A00              push dword 0x0
0000023F  FF1548204000      call dword near [0x402048]
00000245  90                nop
00000246  90                nop
00000247  90                nop
00000248  90                nop
00000249  90                nop
0000024A  90                nop
0000024B  90                nop
0000024C  90                nop
0000024D  90                nop
0000024E  90                nop
0000024F  90                nop
00000250  90                nop
00000251  90                nop
00000252  90                nop
00000253  90                nop
00000254  90                nop
```

There can be no mistake that it is that location between the NOPs where the relevant code is. However, for whatever reason, trying to replace the invoke statement with the same exact code results in a crash. I really don't know much about the Windows API or the macro language of FASM. More research is definitely needed here.
