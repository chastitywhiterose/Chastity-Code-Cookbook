# Assembly Arithmetic Algorithms

32 and 64 bit Windows Edition



# Preface

# Introduction

# Chapter 1: The First Program

Before you can write Windows programs in Assembly language, you will need the FASM Assembler. Be sure to download the Windows version from here:

<https://flatassembler.net/>

The file will probably be named something similar to "fasmw17335.zip"

You will need to extract the files in the zip archive and place them somewhere convenient for you. I placed them in my root C drive directory.

```
C:\fasm
```

Here is an easy way to test and see if the files are correctly located.

Using the command "dir c:\fasm" should return the results of the following files:

```
 Volume in drive C is Windows-SSD
 Volume Serial Number is D43F-B788

 Directory of c:\fasm

08/20/2026  04:00 AM    <DIR>          .
08/20/2026  04:00 AM    <DIR>          EXAMPLES
08/20/2026  04:00 AM           118,272 FASM.EXE
08/20/2026  04:00 AM           529,038 FASM.PDF
08/20/2026  04:00 AM           161,280 FASMW.EXE
08/20/2026  04:00 AM    <DIR>          INCLUDE
08/20/2026  04:00 AM             1,820 LICENSE.TXT
08/20/2026  04:00 AM    <DIR>          SOURCE
08/20/2026  04:00 AM    <DIR>          TOOLS
08/20/2026  04:00 AM            17,640 WHATSNEW.TXT
               5 File(s)        828,050 bytes
               5 Dir(s)   5,106,724,864 bytes free
```

For this book, we will mostly be concerned with FASM.EXE and the INCLUDE directory. I also recommend reading the FASM.PDF file because it is where I learned how to use the FASM Assembler.

The next step is to (temporarily) set your path variables so that you can assemble your source files no matter which folder/directory you happen to be in. Once you have chosen you location to begin coding, you will want to run two commands to set the "path" and "include" variables. I usually place them in a short batch file named fasmpath.bat for convenience.

## fasmpath.bat

```
set path=C:\fasm
set include=C:\fasm\INCLUDE
```

Whether you type those two commands or just place them in a batch file and enter "fasmpath" to execute the script, either way, your paths will be set until you close your console/terminal window. Then all changes will revert to whatever your system defaults were.

There is a GUI setting to permanently change the variables but I DO NOT recommend this because making a mistake can make your system completely unusable. I will explain more about this later.

Anyway, once you have a source file of a valid program, you can assemble it like this.

```
fasm main.asm
```

The file does not have to specifically be named "main.asm". It could just as well be "fartbutt.asm" or even "count-dracula.txt". You can choose whatever seems like a good name to you and adjust the commands accordingly.

To get started, I will provide the first example program that can be assembled and run under the Windows operating system. This was tested on my laptop with Windows 11 but should theoretically work on older versions as well as long as you followed my instructions so far.

Behold,the "Hello World" source file for a Windows console program.

```
```