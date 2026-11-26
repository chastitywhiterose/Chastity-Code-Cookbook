# Chastelib Readme and Manifesto 

Chastelib is a library I have been developing since mid 2025, though some of the functions have existed in some form for 20 years and have been hacked together as I needed them for projects. Over the past 6 months, I have refined them and have extensively documented the source code, and have even begun writing a manual on how to use them. This project will take years, as I have fun improving things and explaining why my own methods of outputting numbers now surpass the capabilities of the C and C++ standard libraries when it comes to printing integers in other bases.

To my knowledge, nobody other than me uses these functions, but they are extremely easy to use by including header files or just copy pasting the functions you like into your own C and C++ projects.

## Core Function List

- **intstr**: Convert an integer to a string in bases 2 to 36
- **strint**: Convert a string in bases 2 to 36 to an integer
- **putstring**: Print a zero-terminated string to standard output
- **putint**: Print an integer using intstr and then putstr

## Rationale

To understand the context of this library and how it came about, you have to know that I have been a C programmer for 25 years. Most of my projects are just toy programs for printing sequences of integers. Even more strange is that I enjoy bases other than ten, referred to as decimal by humans.

Math is a game to me, and I do computer programming for fun. I also think that the C programming language is the best programming language to ever exist. However, there are some limitations that come with it.

The printf family of functions can output formatted text containing arbitrary strings of text with format specifiers and arguments to print integers and floating point numbers.

For integers, there is the %d for decimal, %u for unsigned decimal, %X for hexadecimal, and %o for octal. Although these are the most common number bases used, I prefer the option to print binary. The %b format specifier does exist as a GNU extension, but because I like my code to conform to the 1989 standard, I decided I should write my own set to manage the conversion of integers to and from strings that I can always rely on.

Of the core functions, only putstring uses a C standard library function. It uses the low-level fwrite function to write a string after finding its length by searching for the terminating zero.

Although simple, the putstring allows me flexibility when I am translating chastelib to use a new C library, or when I want to translate all the functions to another programming language.

For example, when using other languages, I can't rely on printf being available. Moreover, printf is a complicated function to write, and I have no idea how it actually works. When I tried translating my functions to Rust, having putstring as my trusted output function helped a lot. That being said, Rust is a painful language, and I stopped because it hurt my head too much, which is saying something, given how good I am at Assembly language on Intel platforms.

The putstring function also helped when I was using ncurses because I could just change putstring to call addstr, which does the same thing in the context of terminal programs written with ncurses.

In fact, the reason putstring returns an integer of how many bytes were written was precisely so it would match the same function signature of addstr from ncurses. This was one of those rare moments where I used a decision in a library written by someone else to influence mine.

The other functions don't read or write to any devices and rely on putstring to show results. However, this means they execute very fast. Not only is C fast because it is a compiled language, but I have incrementally improved my algorithm over months to do the work quickly, and also made the code look good at the same time.

Of all the functions used, strint is used the least because most of the time I am the only one providing input to my programs. If other people were using my programs, they would of course provide strings from the keyboard that would be parsed as integers. I have tested the function to ensure that it works correctly.

In fact, my program chastehex was why the function was originally written. I could have had a generic hexadecimal converting function, but I made one that was flexible and supported any base from 2 to 36.

Technical note: Base 36 is the highest base my functions use because digits 0 to 9 are used for digits less than ten. Letters A through Z are used as 10 to 35, whether they are uppercase or lowercase. The ten digits plus 26 letters of the English Alphabet provide a standard that programmers have used before I was even born. It is a good standard, and so I stuck with it.

## Future Extensions

- floating point conversions
- ncurses utilities
- 
## Extension Libraries

The core functions described in the previous section are the most essential. However, there are times when an extension must be written that is program specific. For example, when making a game using SDL, functions specifically for drawing shapes to the screen or managing colors would be useful.

Such functions that are specific to a game I am making would be an "extension" while "core" functions for converting between integers and strings are useful for all programs. I believe my functions do the job better, and if even if not better, require less of a learning curve to use.

## License

All of my functions are written by me based on the way I wanted them to work, but it is important to mention that my public statement is that I release them under the GNU GENERAL PUBLIC LICENSE Version 3 or later license. Good software requires everyone to be about to use, study, share, and modify. I encourage anyone to use my functions if they find them helpful and to also contact me if they have an even better way of implementing something. You can of course change the behavior of them to better suit the tools, language, and programs you are trying to write.
