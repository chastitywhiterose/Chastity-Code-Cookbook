# Learning POSIX System Calls

I have been doing Assembly language programming for some time now, and yet only today did I take the time to read the documentation and some online examples to help me learn how to use the system calls from C programs.

On Linux systems like the Debian one I use, there are documentation pages already installed. There are hundreds of them, and yet only 6 are required to create all of my command-line tools.


The following commands can be used to read each one of the 6 fundamental system calls available on Linux and Unix systems for C programmers.

## Six Supreme System Calls

```
man 2 open
man 2 close
man 2 read
man 2 write
man 2 lseek
man 2 exit
```

My command line utilities, I have been creating such as chastehex, chastecmp, and chastext used these system calls in their assembly versions. However, I traditionally used the C standard library for the C versions of these programs.

But after reading about the system calls and seeing some examples, I realized that I could make copies and rewrite these tools by calling only system calls. During this process, I learned how much easier they are to use compared to the C library functions.

Here is a summary of each of these functions and how they are used in my programs.

All of my tools use "open" to open a file and then "close" to close it when I am done with it. There can be no confusion as to what these functions do because of their names.

Similarly, "read" and "write" do exactly what their names imply. They operate the same as fread and fwrite do in stdio. But they take only 3 arguments instead of 4, which makes a lot of sense. You give them a pointer, and then you tell them exactly how many bytes you want to read from or write to a file descriptor previously assigned with "open".

The "lseek" function stands for long seek and is capable of moving to a different position in a file before the next read or write operation. Not every program needs this, but chastehex does because one of the arguments is an address in hexadecimal to read or write. Jumping around in a file is sometimes necessary if you are working with large files or the address matters a lot.

The final call to any program is "exit" because it ends the program. There isn't much to say about it except that it also lets you return a number to the operating system. Usually, 0 means no errors happened, and a value of anything else indicates a specific type of error you have defined in your program. All of my programs return 1 if a file could not be opened.

Each of these functions has various arguments that have clearly defined meanings. The return values are also specified in their manual pages.

Interestingly, these calls are available on every operating system that I know about except for Windows. However, considering how easy these are to implement using the C standard library, it would be possible to write Windows versions of these. In fact, some people have already done this.

See the Cygwin and MinGW projects for more information about how to use these calls on Windows. For all other operating systems: Linux, Unix (FreeBSD,  OpenBSD, NetBSD, Minix, and ChromiumOS)
These calls are already available if you have a working C compiler.

You might wonder why I spent the time learning and explaining this. It is because having a super small library of functions that I can memorize allows faster programming and less time spent looking at my references when I have forgotten which order the arguments go in.

This knowledge gives me an alternative library of functions I can use that is easier than the C standard library. However, I am keeping both versions of every program I have written.

But the final point I want to make is that because these are the same calls used in my Assembly programs, I can make C programs that map 1 to 1 when comparing and teaching Assembly in the books I write!

