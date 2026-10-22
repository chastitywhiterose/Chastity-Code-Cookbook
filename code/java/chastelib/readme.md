# Chastelib Readme and Manifesto: Java Edition

Chastelib is a library I have been developing since mid 2025, though some of the functions have existed in some form for 20 years and have been hacked together as I needed them for projects. I have refined them and have extensively documented the source code, and have even begun writing a manual on how to use them. This project will take years, as I have fun improving things and explaining my own methods of outputting numbers.

The original library was written in C, but this Java port retains the spirit of what the functions do, even though Java has a first restrictions compared to C and C++.

To my knowledge, nobody other than me uses these functions, but they are extremely easy to use by copying pasting the functions you like into your own Java projects.

## Core Function List

- **intstr**: Convert an integer to a string in bases 2 to 36
- **strint**: Convert a string in bases 2 to 36 to an integer
- **putstr**: Print a string to standard output
- **putint**: Print an integer using intstr and then putstr

## Rationale

To understand the context of this library and how it came about, you have to know that I have been a C programmer for 25 years. Most of my projects are just toy programs for printing sequences of integers. Even more strange is that I enjoy bases other than ten, referred to as decimal by humans.

Math is a game to me, and I do computer programming for fun. I also think that the C programming language is the best programming language to ever exist. However, there are some limitations that come with it.

One key difference between C and Java is that C's standard library is pretty small. Java has a huge standard API of functions, including those that convert between bases. However, writing my own code and reinventing the wheel has always proven to be a better learning experienct and more fun that navigating though API documentation.

But the syntax of Java is already very "C-like" with curly braces for blocks of functions or conditional loops. There was very little effort required to convert most of the C code into Java.

In summary, my rationale is that by writing the same functions in each new programming language, I already know how the algorithm works because the code was 100% written by me and works the same no matter what language I am using with only a few syntax changes.

## License

All of my functions are written by me based on the way I wanted them to work, but it is important to mention that my public statement is that I release them under the GNU GENERAL PUBLIC LICENSE Version 3 or later license. Good software requires everyone to be about to use, study, share, and modify. I encourage anyone to use my functions if they find them helpful and to also contact me if they have an even better way of implementing something. You can of course change the behavior of them to better suit the tools, language, and programs you are trying to write.
