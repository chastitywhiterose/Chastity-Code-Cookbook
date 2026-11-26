# C Without Printf

Build a Low-Level I/O Library From Ground Zero

# Preface

In this book, I intend to give new programmers a quick introduction to the C Programming Language, its history, and how to use it for the problems it was designed to be used for. The C language refuses to die, despite bogus claims from online trolls who are probably not very good programmers.

In 1973, Dennis Ritchie and Ken Thompson rewrote the Unix operating system from PDP-11 Assembly language into C. Until this time, high-level languages were just too slow to be usable on the hardware available. C changed the world because it became a Portable Assembly Language. That is, each operating system with a C compiler can translate C code into Assembly language.

In 1978, Brian Kernighan and Dennis Ritchie published the first edition of the book: The C Programming Language. This book became the unofficial standard for how programmers learned to use the language.
A second edition of the book was published in 1988, which reflected some improvements since the original book after the language had evolved. This book is still [available](https://www.amazon.com/dp/0131103628) and is essential for anyone who needs a complete understanding of the language.

In 1989, the language was standardized by the American National Standards Institute. This is referred to as ANSI for short, and is the origin of the **-ansi** compiler flag, which is used in popular compilers like GCC and Clang. Having a standard is important for making programs that can run on the maximum number of possible machines, despite them having different Central Processing Units(like Intel, ARM, or RISC-V) and operating systems(Linux, DOS, Windows, macOS). Because of C's reputation as a Portable Assembly Language, it is usually recommended by experts as a great programming language to start with if you have not done programming before.

I was born in 1987, and am blessed to see how far technology has improved during my lifetime. I have also seen many failed attempts to replace C with newer languages such as Java, Rust, and Zig. However, people are mistaken about the reasons the C programming language has been in use for over 50 years since it was invented as an extension of the B programming language. When I was 14, I learned C, and now, at the age of 39, I have 25 years of experience using it as my dominant language.

People who have read my Assembly Arithmetic Algorithms series will feel at home in this book because I use it to teach fundamental computer science principles, even when this requires teaching difficult subjects like pointers. It is worth mentioning that every single program from my Assembly books started as a C program first because it is the fastest language for me to write new tools in and finish designing them before I model the Assembly program to behave the same way.

The reason that this book is titled "C Without Printf" is because it shows how to build an input/output library from more basic low-level functions. Although **printf** is an extremely useful function that is part of the C Standard Library, programmers tend to rely on it so much that they don't learn the bits and bytes that make up the numbers and strings they are trying to print.

My opinion on the printf function is the same as my opinion on other programming languages like C++, Java, and Python. These languages do a lot of extra things for the programmer and, in my opinion, have caused some of them to become lazy and just let compilers and standards organizations bring them new features and functions rather than learning anything about how computers work.

Such programmers may get started programming and may even write useful and fun programs, but then when they learn a new programming language or face a new problem, they are left without the fundamental knowledge to solve it. My book is intended to fix this failure of how computer programming is taught.

To sum this book up in a sentence: You must learn to walk before you can drive a car. By this, I mean that you will move slower at first, but when the road is covered in ice and it is unsafe to drive, you can remember how to walk the difficult path through the grass, dirt, and snow.

***Where we're going, we don't need roads" - Christopher Lloyd in Back to the Future(1985)***

# Introduction

Before we can begin programming in C, we must decide on which tools we will need. In this book, I only promote Free and open-source tools. What this means to the layperson is that they will be available in some form regardless of which Operating System you are using. I personally use Debian Linux for writing all of my books and programming. I recommend Debian or something similar to it for your introduction to Linux as an operating system.

## Installing GCC on Linux

If you are using Debian or Ubuntu Linux, installing the GCC compiler is as simple as:

```
sudo apt install gcc
```

If you are using a different Linux distribution, see the official documentation for it to see what is required to install it, or perhaps check if it is already installed. This is more common than you might think.

## Installing GCC on Windows

However, I expect that most of my readers have a computer with the Windows operating system installed since the computer was purchased. Don't worry, you can still follow along!

### Method 1: Scoop

When I bought my Windows 11 laptop, I set up [Scoop](https://scoop.sh/) to be my command-line installer. Then I installed GCC so that I could always have it available from the command line on Windows, just like I could in Linux.

Scoop is pretty easy to use as a command-line package manager for not only GCC but also other applications and games that you might not have heard of. I highly recommend it as something to try for people getting started programming on Windows. If you follow the directions, it is not hard.

<https://scoop.sh/>

After you have installed Scoop, use this command:

```
scoop install gcc
```

### Method 2: w64devkit

Besides Scoop, another method that I tend to use myself is w64devkit: a software kit developed by [skeeto](https://github.com/skeeto) on GitHub, which is a convenient way to get a working copy of GCC and other useful tools that may assist you in programming on Windows.

By downloading [w64devkit](https://github.com/skeeto/w64devkit), you get [Mingw-w64 GCC](https://www.mingw-w64.org/), [GNU Make](https://www.gnu.org/software/make/), and [busybox](https://frippery.org/busybox/). These tools will allow you to compile and run C programs, run advanced tasks with makefiles for GNU Make, and run most Linux commands (ls, cat, etc.).

The reason I recommend it is because it allows you to develop any program exactly the way you would on Linux without having to install Linux. Most people don't use Linux unless they are already into programming. If you are getting your start with C programming and your computer has Windows, then you will benefit from this section.

Go to the repository here and go to the releases page. You will find several releases. You will be fine going with the latest version, whichever it is.

<https://github.com/skeeto/w64devkit/releases>

The files with "x64" in their name refer to the modern Windows version that runs on 64-bit processors (usually this means Windows 7, 8, 10, or 11). Most of the time, this is what you want.

At the time of this writing, the latest version of w64devkit is [2.4.0](https://github.com/skeeto/w64devkit/releases/tag/v2.4.0). This means that the file to download is:

`w64devkit-x64-2.4.0.7z.exe`

Run the executable, and it will allow you to extract the files into their full folder. Inside will be a file named:

`w64devkit.exe`

If you run it, you will be inside a little environment that operates a lot like Linux. You can run gcc and compile the same way you would in Linux.

There are other ways to install GCC on Windows. However, all of them will give you the ability to type gcc into the terminal or console to compile and run your C code.

Once it is installed correctly, you can enter `gcc` and get the message:

```
gcc: fatal error: no input files
compilation terminated.
```

You can also check which version of GCC is installed with "gcc --version". For example, on my machine it reveals:

```
gcc (Debian 12.2.0-14+deb12u1) 12.2.0
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

After you have installed GCC, or perhaps another C compiler (Clang also works well), you will need to create a text file in a text editor. There are many good text editors, and you can use whatever is already installed on your operating system. However, if you are looking for an editor with syntax highlighting for C programming, I highly recommend either Geany for any OS or Notepad++ for Windows.

<https://www.geany.org/>

<https://notepad-plus-plus.org/>

## The First Program

Once you have installed GCC and your favorite text editor, create the following file:

```
#include <stdio.h>

int main(int argc, char *argv[])
{
 char s[]="Hello World\n";
 int count=0;
 const char *p=s;
 while(*p){p++;}
 count=p-s;
 fwrite(s,1,count,stdout);
 return 0;
}
```

The command to compile and run this program, assuming its name was main.c, would be:

```
gcc -Wall -ansi -pedantic main.c -o main && ./main
```

You should see this message in your terminal:

```
Hello World
```

The flags "-Wall -ansi -pedantic" as part of that command compile with very strict conformance to standards. Fun fact: I use those flags specifically because they were recommended in the FreeBSD Developers' Handbook.

<https://docs.freebsd.org/en/books/developers-handbook/tools/#tools-compiling>

FreeBSD is an operating system based on Unix. It works very similarly to Linux, but the main reason I refer to it is because of all the open-source tools it recommends.

One thing that I do in my own development is create a makefile with different rules for compiling my source code. You can see it below for reference.

## makefile

```
strict:
	gcc -Wall -ansi -pedantic main.c -o main && ./main
strip:
	gcc -Wall -ansi -pedantic main.c -o main -s
simple:
	gcc main.c -o main && ./main
clang:
	clang -Wall -ansi -pedantic main.c -o main && ./main
tcc:
	tcc main.c -o main && ./main
zig:
	zig cc -Wall -ansi -pedantic main.c -o main && ./main
```

The make utility is really easy to use. Just typing "make" at the command line will use the first rule in the makefile which compiles and runs it with the strict flags. The other rules are mostly for testing other compilers. For example, "make tcc" compiles with the [Tiny C Compiler](https://bellard.org/tcc/) by Fabrice Bellard. For context, Fabrice is also the genius guy who made QEMU, the PC emulator, and FFmpeg, the video/audio media converter.

If you have followed the directions for installing a C compiler and running the first program, you are on your way to becoming a great programmer. I will be explaining each line of the program and providing alternative ways you might like to print text.

It might seem basic right now, but there is a specific reason I used fwrite to display the output instead of cheating with printf or fputs. I believe that to use the C language effectively, someone must get comfortable with data types, arrays, and pointers as soon as possible rather than learning to do things the wrong way and then quitting when they get frustrated. I promise you, it does get easier rather than harder.

# Chapter 1: Commentary on The First Program

In the introduction, I showed you the full source of a program that displays "Hello World" to the terminal. This chapter will analyze it in more detail because it is a good example of a well written program.

A C program can include comments right inside the source. The following is the same program except with the comments included. I will explain more what each of these lines are actually doing.

```
/*include the standard input output library*/
#include <stdio.h>
/*the main function where all C programs begin*/
int main(int argc, char *argv[])
{
 /*an array of characters*/
 char s[]="Hello World\n";
 /*used to count how many bytes will be written*/
 int count=0;
 /*pointer used to find terminating zero of string*/
 const char *p=s;
 /*loop until zero found and immediately exit*/
 while(*p){p++;}
 /*count is the difference of pointers p and s*/
 count=p-s;
 /*https://cppreference.com/w/c/io/fwrite.html*/
 fwrite(s,1,count,stdout);
 /*return to operating system with exit code 0*/
 return 0;
}
```

## Each Line Explained

```
#include <stdio.h>
```

The #include directive literally copies and pastes the full contents of the file given inside the lesser and greater signs. In this case, these symbols mean that it is a standard library header file which is provided along with the installed compiler. The file "stdio.h" is always provide because the standard mandates it. Inside it are many functions, although the one we are interested in is fwrite, which is on a later line.

```
int main(int argc, char *argv[])
```

All programs begin at a function named main. The main function contains variables named argc and argv. They are not used in this program but I will teach you the proper usage of these in a future chapter. For now, remember the types "int" and "char".

An int is a short name for integer, which can be any whole number such as 0, 1, 2, 3, etc. but can not be fractional such as 2.5 or 3.14. Fractional numbers are referred to as floating point variables but we are not using them right now.

A char is a short name for an character. Technically it is also an integer because C uses 8-bit bytes as characters. Therefore a character can be anything from 0 to 255 if the number is unsigned(a type of integer that is always positive), or it can be from -128 to +127 if the number is signed(a type that can contain positive and negative numbers.).

Finally, take note that int is defined as type int. This means that the function will return a number as an exit code when it returns to the operating system.

```
{
```

The opening curly brace always follows a function name and its arguments. It can occur on the same line or it can follow on the line after. I prefer it on the line afterwards because I find it more readable to my eyes.

```
 char s[]="Hello World\n";
```

This is a character array named s. The `[]` means that it is a constant array. You can initialize an array constant only once, but it can be read or written to an infinite number of times. The purpose of the s array is to be used as a message sent to the screen.

```
 int count=0;
```

The count variable is created and initialized to 0. It will later be updated with some arithmetic later.

```
 const char *p=s;
```

The p variable is named p because it is my short name for a pointer. The asterisk prefixing the name of it means that we want it to be a pointer instead of a regular character. In this case, it points to a constant array of characters. By this I mean that the location of those characters is constant, but that does not mean that p will always point to the same location. Here, p is initialized to s, meaning that it points to the first character of the s array.

```
 while(*p){p++;}
```

This one line magic trick is a loop. We know that p points to the address of the first character in s. However, an asterisk prefixing it refers to the actual character pointed to.

The "while" keyword has a conditional statement in the parenthesis next to it. This means that *p will begin at the letter 'H' in the s string. However, inside the curly brackets next to it, we see the statement "p++;". This means that we are adding 1 to the address pointed to by p. Therefore, it starts as the 'H' but then will go to 'e','l','l','o',' ','W','o','r','l','d','\n', and finally the hidden zero byte.

The zero byte is something that a C compiler always adds whenever we define a string constant in double quotation marks. As soon as p points to the zero byte, the while loop will end. This happens because 0 means false but any other number means true. The statement will be true while p passes through all the other characters, but is immediately false when the zero byte is encountered.

Also, in case you are wondering, the character '\n' means a newline character. This is what usually happens when you press the enter key, but here we have included it manually.

You may also notice that we used curly braces to define the beginning and end of the while loop. It seems silly because this loop only has one statement, but in larger loops, you will require this for readability.

```
 count=p-s;
```

Here the count variable is updated to have the exact number of characters in the string. Remember, after the loop, p points to the address of character zero but s still starts at the 'H' in "Hello World\n". So what we have done is say that count is equal to address p minus address s. This will always be a positive number that represents how many characters are in the string. Therefore, now you can see that the only reason we did the while loop was to seek ahead and find the zero so we could do this essential subtraction operation.

```
 fwrite(s,1,count,stdout);
```

Now we get to use the fwrite function. This function takes 4 arguments. The best documentation page for it is here:

<https://cppreference.com/w/c/io/fwrite.html>

I will attempt to summarize these four arguments in my own way.

1. pointer to an array, buffer, string, struct, etc. The actual data pointed to can be of any type. For this program we have used s as the address because it is where our array is.
2. size of the data type being written. This is 1 for this example because a char is always 1 byte in size.
3. count of how many items are being written. We have already obtained the number of characters in the string with the previous lines, so we use it for the third argument to fwrite.
4. The fourth and final argument is the file stream to send the data to. The name stdout refers to standard output. This is an output stream that is always available in a C program right from the start. Anything sent to it shows up on the screen. Remember that the terminal is considered a special case of a file but is different than the kind of file you open in a text editor.

```
 return 0;
```

Now that the job of writing the text to the terminal is done, there is nothing left to do except return to the operating system. The "return 0;" statement returns the number zero back to the OS, which usually means that no errors happened.

```
}
```

The last line is just the closing curly brace of the main function. You must be sure to include it because it is essential for the compiler to keep the boundaries or where a function, loop, or other block of code begins and ends.

## Bonus Exercise

The following program is the same as before, except that a new loop was added to print he string in reverse after it was printed forwards.

```
/*include the standard input output library*/
#include <stdio.h>
/*the main function where all C programs begin*/
int main(int argc, char *argv[])
{
 /*an array of characters*/
 char s[]="Hello World\n";
 /*used to count how many bytes will be written*/
 int count=0;
 /*pointer used to find terminating zero of string*/
 const char *p=s;
 /*loop until zero found and immediately exit*/
 while(*p){p++;}
 /*count is the difference of pointers p and s*/
 count=p-s;
 /*https://cppreference.com/w/c/io/fwrite.html*/
 fwrite(s,1,count,stdout);
 /*a second loop to print the string backwards*/
 while(p!=s)
 {
  p--;
  fwrite(p,1,1,stdout);
 }
 /*return to operating system with exit code 0*/
 return 0;
}
```

When you run it, you should see the following output.

```
Hello World

dlroW olleH
```

I want you to think about why the new loop prints the character array backwards. It is okay if you don't understand it completely right now, but it will become more clear later when I teach you about conditional statements and comparisons.
