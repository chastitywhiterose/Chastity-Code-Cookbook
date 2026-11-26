In this book, I intend to give new programmers a quick introduction to the C Programming Language, its history, and how to use it for the problems it was designed to be used for. The C language refuses to die, despite bogus claims from online trolls who are probably not very good programmers.

In 1973, Dennis Ritchie and Ken Thompson rewrote the Unix operating system from PDP-11 Assembly language into C. Until this time, high-level languages were just too slow to be usable on the hardware available. C changed the world because it became a Portable Assembly Language. That is, each operating system with a C compiler can translate C code into Assembly language.

In 1978, Brian Kernighan and Dennis Ritchie published the first edition of the book: The C Programming Language. This book became the unofficial standard for how programmers learned to use the language. A second edition of the book was published in 1988, which reflected some improvements since the original book after the language had evolved. This book is still essential for anyone who needs a complete understanding of the language.

In 1989, the language was standardized by the American National Standards Institute. This is referred to as ANSI for short, and is the origin of the **-ansi** compiler flag, which is used in popular compilers like GCC and Clang. Having a standard is important for making programs that can run on the maximum number of possible machines, despite them having different Central Processing Units(like Intel, ARM, or RISC-V) and operating systems(Linux, DOS, Windows, macOS). Because of C's reputation as a Portable Assembly Language, it is usually recommended by experts as a great programming language to start with if you have not done programming before.

I was born in 1987, and am blessed to see how far technology has improved during my lifetime. I have also seen many failed attempts to replace C with newer languages such as Java, Rust, and Zig. However, people are mistaken about the reasons the C programming language has been in use for over 50 years since it was invented as an extension of the B programming language. When I was 14, I learned C, and now, at the age of 39, I have 25 years of experience using it as my dominant language.

People who have read my Assembly Arithmetic Algorithms series will feel at home in this book because I use it to teach fundamental computer science principles, even when this requires teaching difficult subjects like pointers. It is worth mentioning that every single program from my Assembly books started as a C program first because it is the fastest language for me to write new tools in and finish designing them before I model the Assembly program to behave the same way.

The reason that this book is titled "C Without Printf" is because it shows how to build an input/output library from more basic low-level functions. Although **printf** is an extremely useful function that is part of the C Standard Library, programmers tend to rely on it so much that they don't learn the bits and bytes that make up the numbers and strings they are trying to print.

My opinion on the printf function is the same as my opinion on other programming languages like C++, Java, and Python. These languages do a lot of extra things for the programmer and, in my opinion, have caused some of them to become lazy and just let compilers and standards organizations bring them new features and functions rather than learning anything about how computers work.

Such programmers may get started programming and may even write useful and fun programs, but then when they learn a new programming language or face a new problem, they are left without the fundamental knowledge to solve it. My book is intended to fix this failure of how computer programming is taught.

To sum this book up in a sentence: You must learn to walk before you can drive a car. By this, I mean that you will move slower at first, but when the road is covered in ice and it is unsafe to drive, you can remember how to walk the difficult path through the grass, dirt, and snow.

***Where we're going, we don't need roads" - Christopher Lloyd in Back to the Future(1985)***
