# Chastity's Code Cookbook

Computer Programming Recipes for Technical Math Nerds

Chastity White Rose

# Preface

You would not know it by looking at me, but I have been computer programming as a hobby since I was 14 years old. My first programming language was QBASIC. It was a language and a program for interpreting that language that ran on MS-DOS. However, the usage of this language has diminished in use over time because it does not run without an emulator or modern BASIC language dialects meant to mimic it.

However, I moved to the C Programming Language as my main computer language. I have dabbled in Java, JavaScript, Lua, Perl, Python, and the beast known as C++. However, of all these languages, C remains my native language because of how simple it is to remember. In spite of its quirks, C is what I recommend to a beginner, not in spite of its limitations but because of them! Therefore, most of the recipes in this code cookbook will be in the form of C source code.

But this book will contain more than just the C language. There are times when other languages, such as Bash, HTML, Markdown, and maybe even Lua or Python, will just make a lot more sense in the context of what is being done.

For example, computer programming is used to create art, web pages, books, and video games. However, programming is also hard work and a lonely pursuit because almost nobody understands it except those of us who are called to this sacrificial art of communicating with a computer.

That being said, my computer understands what I mean better than most humans do. The purpose of this book is to archive some of the best programs I have written, and yet at the same time, they are simple enough to share in only one or two pages.

This project began as an effort to save all my work so that it would not be lost. I also hope that new generations of computer programmers can learn something from my 20+ years of experience as a C programmer.

# Introduction

I got my start in the world of computer programming because I first loved numbers. I am the stereotype of an autistic savant who sees everything as a number. If you like numbers, my hope is that my recipes for generating number patterns will be of some use to you.

And if you don't like numbers, then you probably won't do well as a computer programmer because everything is a number in the context of a computer. The size, shape, and color of every text or picture element in the video games you play were, at one point, written into the code by one or more programmers who probably were not paid enough for the work that went into their craft!

But before I begin sharing my code recipes with you, there is something I need to do before you can fully enjoy the experience. You will want to install a C compiler on your computer!

If you are using Debian or Ubuntu Linux, installing the GCC compiler is as simple as `sudo apt install gcc`. However, I expect that most of my readers have a computer with the Windows operating system installed since the computer was purchased.

Don't worry, you can still follow along! When I bought my Windows 11 laptop, I set up [scoop](https://scoop.sh/) to be my command-line installer. Then I installed GCC so that I can always have it available from the command line on Windows, just like I could in Linux.

`scoop install gcc`

There are other ways to install GCC on Windows. However, all of them will give the result of having the ability to type gcc into the terminal or console to compile and run your C code.

Once it is installed correctly, you can enter `gcc` and get the message:

gcc: fatal error: no input files
compilation terminated.

But that is okay! We are going to give it an input file to compile! Type the following into a text file named main.c.

```
#include <stdio.h>
int main()
{
 printf("Hello, World!\n");
 return 0;
}

```

You can compile this and run from the command line with:

`gcc main.c -o main && main`

If done correctly while at a command line in the same folder as the source file, you will get the message:

`Hello, World!`

If you see this, then it means that the program compiled and ran successfully.

You see, the command `gcc main.c -o main && main` is actually two commands in one. The first part

`gcc main.c -o main`

tells the compiler to process it and create an executable file. The second part

`main`

Tells it to run the executable file. On Windows, this would run a program named "main.exe". On Linux, the file is likely to be named simply "main". Also, on Linux, you would need to write it as "./main" to execute it. This signals that the file you are trying to run is in the current directory.

## How it works

Now that you have successfully ran the Hello World program, you might be wondering what it all means. Here is the same program with comments included.

```
#include <stdio.h> /*include the standard input and output library*/
int main() /*beginning of a function named main which returns an integer*/
{ /*opening bracket starting the function block*/
 printf("Hello, World!\n"); /*calling printf, the most useful function in the C Programming Language.*/
 return 0; /*Return the number zero to the operating system. This means no errors occurred.*/
} /*closing bracket ending the function block*/

```

Once you can get this program working, then the rest of the C source code samples in this book will work fine! They all use elements of the C Standard Library. The file "stdio.h" is one of the library files.

I will do my best to explain the usage of functions as they are introduced. However, for more information, it is better to go to an online reference such as [cppreference.com](https://en.cppreference.com/w/c.html) for more information than I have included.

For example, you can find on there the usage of the [printf](https://en.cppreference.com/w/c/io/fprintf.html) family of functions. Arguably, printf is the most used function in C because of its ability to output strings of text and numbers to display any useful information to the user of the program. Without output, you would have no way of knowing whether your code was correct.

I do not use all of the functions in the standard library. In fact, I would say that most of the functions and features of the C language I have never learned because I never needed to. The reason for this will become more clear in Chapter 1 when I cover what I do best: writing code to generate integer sequences.

# Chapter 1: Integer Sequences

An integer is a whole number. For example, 1,2,3,4,5 etc are all integers. Negative numbers like -15 or -23 are also integers.

Things that are not an integer include anything that comes with a decimal point. For example, Pi:

3.14159265358979323846

Or the Square root of 2.

1.41421356237309504880

Integers, specifically positive integers are the focus of this chapter. I will start with a code sample that generates all the integers up to 100.

## Count 100

```
#include <stdio.h>
int main()
{
 int a=0;
 while(a<=100)
 {
  printf("%d ",a);
  a++;
 }
 return 0;
}
```

If done correctly, you will see the following in your terminal.

---

0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100

---

How this works is very simple. with `int a=0;` We define an integer named a that starts at 0. Then we set up a while conditional block defined by `while(a<=100)` which means that the following block will happen as long as a is less than or equal to 100.

Just like the main function, each block begins with a { and ends with a }. This is common for languages like C, C++, Java, and JavaScript.

There are two statements in this block. The first is:

`printf("%d ",a);`

Says that we are going to print a **d**ecimal integer followed by a space. The second argument (or option) to the printf function is the variable 'a'.

The next statement:

`a++;`

Is a short way of saying "add 1 to a". You could just as easily write "a=a+1;" or "a+=1;"

Upon this foundation, all other integer sequence code is written. There are always these steps.

- Define the variables used
- Set up the looping conditionals
- One or more statements defining the math

One important misunderstanding about computer programming is that some people think it is related to algebra. Not in the slightest. I failed at algebra more times than I can count but this is not like that. As a computer programmer, I get to say what the variables are and how they change. Algebra is different because you are trying to discover what someone else decided a,b,c or x,y,z are. Where is the fun in that?!

But computer programming can be fun if you know how to write it. As you look at my next samples, you may begin to understand why I enjoy it.

## The Powers of 2

The powers of 2 are an interesting sequence because of their application in computer science (computers work in the binary numeral system, not decimal) as well as biology. It is extremely easy to write a basic program to generate the sequence of the powers of 2.

```
#include <stdio.h>
int main()
{
 int a=0,b=32,c=1;
 while(a<=b)
 {
  printf("2 ^ %2d = %11d\n",a,c);
  a++;
  c+=c;
 }
 return 0;
}
```

This short program generates the powers of two sequence. It starts at 1 and doubles the number each time by adding it to itself. The output is as follows.

```
2 ^  0 =           1
2 ^  1 =           2
2 ^  2 =           4
2 ^  3 =           8
2 ^  4 =          16
2 ^  5 =          32
2 ^  6 =          64
2 ^  7 =         128
2 ^  8 =         256
2 ^  9 =         512
2 ^ 10 =        1024
2 ^ 11 =        2048
2 ^ 12 =        4096
2 ^ 13 =        8192
2 ^ 14 =       16384
2 ^ 15 =       32768
2 ^ 16 =       65536
2 ^ 17 =      131072
2 ^ 18 =      262144
2 ^ 19 =      524288
2 ^ 20 =     1048576
2 ^ 21 =     2097152
2 ^ 22 =     4194304
2 ^ 23 =     8388608
2 ^ 24 =    16777216
2 ^ 25 =    33554432
2 ^ 26 =    67108864
2 ^ 27 =   134217728
2 ^ 28 =   268435456
2 ^ 29 =   536870912
2 ^ 30 =  1073741824
2 ^ 31 = -2147483648
2 ^ 32 =           0
```

Everything looks nice here. I even aligned the digits of the output to make it beautiful. It is all fine until we get 2 to the 31st power. Why is it negative?! Why is 2^32 now 0?

I understand it because I know how integer sizes work on computers. An int type in the C language is usually a 32 bit integer and so it can only contain 32 bits (binary digits) which represent the sum of powers of two that can represent any integer up to that limit. However, because numbers are infinite, at some point data is lost and we end up back at zero.

For a complete understanding on the topic of the binary numeral system, I would probably have to write a whole book on it as well. However, for now, I will show you that through clever code writing, it is possible to break this limit and go far beyond this wall that the last program runs into.

The following program may scare you a little bit. It uses an array of decimal digits to represent a number instead of using the built in machine integers. However messy it looks, it certainly does the job.

## Advanced Powers of 2

```
#include <stdio.h>
int main()
{
 int a=0,b=64;

 int x,y;
 #define length 1000
 int length2=20;
 char c[length];

 x=0;
 while(x<length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;

 while(a<=b)
 {
  printf("2 ^ %2d = ",a);
  a++;

  x=length2;
  while(x>0)
  {
   x--;
   printf("%d",c[x]);
  }
  printf("\n");

  y=0;
  x=0;
  while(x<=length2)
  {
   c[x]+=c[x];
   c[x]+=y;
   if(c[x]>9){y=1;c[x]-=10;}else{y=0;}
   x++;
  }
  if(c[length2]>0){length2++;}

 }
 return 0;
}
```

The output is the following:

```
2 ^  0 = 00000000000000000001
2 ^  1 = 00000000000000000002
2 ^  2 = 00000000000000000004
2 ^  3 = 00000000000000000008
2 ^  4 = 00000000000000000016
2 ^  5 = 00000000000000000032
2 ^  6 = 00000000000000000064
2 ^  7 = 00000000000000000128
2 ^  8 = 00000000000000000256
2 ^  9 = 00000000000000000512
2 ^ 10 = 00000000000000001024
2 ^ 11 = 00000000000000002048
2 ^ 12 = 00000000000000004096
2 ^ 13 = 00000000000000008192
2 ^ 14 = 00000000000000016384
2 ^ 15 = 00000000000000032768
2 ^ 16 = 00000000000000065536
2 ^ 17 = 00000000000000131072
2 ^ 18 = 00000000000000262144
2 ^ 19 = 00000000000000524288
2 ^ 20 = 00000000000001048576
2 ^ 21 = 00000000000002097152
2 ^ 22 = 00000000000004194304
2 ^ 23 = 00000000000008388608
2 ^ 24 = 00000000000016777216
2 ^ 25 = 00000000000033554432
2 ^ 26 = 00000000000067108864
2 ^ 27 = 00000000000134217728
2 ^ 28 = 00000000000268435456
2 ^ 29 = 00000000000536870912
2 ^ 30 = 00000000001073741824
2 ^ 31 = 00000000002147483648
2 ^ 32 = 00000000004294967296
2 ^ 33 = 00000000008589934592
2 ^ 34 = 00000000017179869184
2 ^ 35 = 00000000034359738368
2 ^ 36 = 00000000068719476736
2 ^ 37 = 00000000137438953472
2 ^ 38 = 00000000274877906944
2 ^ 39 = 00000000549755813888
2 ^ 40 = 00000001099511627776
2 ^ 41 = 00000002199023255552
2 ^ 42 = 00000004398046511104
2 ^ 43 = 00000008796093022208
2 ^ 44 = 00000017592186044416
2 ^ 45 = 00000035184372088832
2 ^ 46 = 00000070368744177664
2 ^ 47 = 00000140737488355328
2 ^ 48 = 00000281474976710656
2 ^ 49 = 00000562949953421312
2 ^ 50 = 00001125899906842624
2 ^ 51 = 00002251799813685248
2 ^ 52 = 00004503599627370496
2 ^ 53 = 00009007199254740992
2 ^ 54 = 00018014398509481984
2 ^ 55 = 00036028797018963968
2 ^ 56 = 00072057594037927936
2 ^ 57 = 00144115188075855872
2 ^ 58 = 00288230376151711744
2 ^ 59 = 00576460752303423488
2 ^ 60 = 01152921504606846976
2 ^ 61 = 02305843009213693952
2 ^ 62 = 04611686018427387904
2 ^ 63 = 09223372036854775808
2 ^ 64 = 18446744073709551616
```

The concept of an array is really easy to explain. An array is a list of numbers. In the program above, variable 'c' is not one number but a list of 1000 numbers. With `#define length 1000` we declared a compiler constant representing the maximum length the array can be. With `int length2=20;` we declared the length of the number of digits we want printed. Finally, with `char c[length];` we declared the array of integers named 'c' rather than just one integer.

If you are wondering why 'c' is defined as type "char" instead of "int", that is just to save memory. A char is an 8 bit integer instead of the usual 32 bit. For our purpose in this program, this is more than enough.

The first loop in this code initializes the entire array with zeros. The x variable is used only as an index variable but has no special meaning on its own.

```
 x=0;
 while(x<length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;
```

Literally it is setting everything from `c[0]` to `c[999]` to 0. Then it sets `c[0]` equal to 1; This lowest element represents the ones place. Elements 1,2,3 and so on represent the tens, hundred, thousands, etc.

Most parts of this program are still the same as the simple one. Variables 'a' and 'b' control how many times the big loop goes.

```
  x=length2;
  while(x>0)
  {
   x--;
   printf("%d",c[x]);
  }
  printf("\n");
```

By starting at length2, we decide at what point to begin printing the digits. Each time, 'x' is decreased by 1 and we print the current element represented by `c[x]`.

And finally, the real magic happens in this part.

```
  y=0;
  x=0;
  while(x<=length2)
  {
   c[x]+=c[x];
   c[x]+=y;
   if(c[x]>9){y=1;c[x]-=10;}else{y=0;}
   x++;
  }
  if(c[length2]>0){length2++;}
```

Variable 'y' is used as a "carry" in the addition process. We are starting at the bottom of the array and adding each digit to itself. Then we add the carry variable to the current digit.

Then, we have an "if statement" to execute if the digit goes higher than 9. If this happens, we subtract ten from it and then set the carry to 1. Otherwise, we set the carry back 0 zero.
Finally at the end of this loop is a conditional that automatically increases the length 2 variable if the carry has caused it to be higher than zero. This makes an automatically expanding list of decimal digits.

As you might guess, I spent many hours perfecting this powers of two program. I wanted it fast but I also tried to make it clear and readable. For an experienced programmer, this is nothing, but it is the kind of code that makes non-programmers confused and they think I am a genius.

And maybe I am, but the point is that I only instructed the computer to do what I already know how to do on paper and in my mind. The same process of addition applies when adding a deposit to a check register for example.

## The Prime Numbers

The prime numbers are a fun study for many people. The definition of a prime number is that it has exactly two factors (the number itself and 1). For example 7 is a prime number because it is not divisible by anything else other than 1. 9 is not prime because 3 times 3 equals 9.

```
#include <stdio.h>
int main()
{
 int x,y;
 #define length 1000
 char c[length];

 x=0;
 while(x<length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;

 printf("2 ");
 x=3;
 while(x<length)
 {
  printf("%d ",x);
  y=x;
  while(y<length)
  {
   c[y]=1;
   y+=x;
  }
  while(x<length && c[x]>0){x+=2;}
 }
 
 return 0;
}

```

This program is relatively short considering that it finds all the prime numbers less than 1000 very efficiently.

---

2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379 383 389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503 509 521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631 641 643 647 653 659 661 673 677 683 691 701 709 719 727 733 739 743 751 757 761 769 773 787 797 809 811 821 823 827 829 839 853 857 859 863 877 881 883 887 907 911 919 929 937 941 947 953 967 971 977 983 991 997

---

Like my powers of two program, it uses an array named 'c'. However, this time we are using the array as indexes in a prime finding process called the [Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).

We are simply going through the array each time a prime number is found and then marking each index as a multiple of that number. Afterwards, the index goes to the next element which is still a zero, meaning that no factors have been found for this number.

## Conclusion

The examples I have added in this chapter have shown the required elements of writing effective code. Knowing how to set integer variables (or arrays of them) is required for generating integer sequences. I can also add programs to this chapter for other sequences upon request if anyone has a sequence that they think is worth including.

# Chapter 2: Graphics

While most of the focus of this book is about generating text information, such as the integer sequences of Chapter 1, there is a lot more potential that you may not realize at first. If we consider that all programming, scripting, and markup languages are created using text, it leads to the idea that we can use C in combination with other languages to generate pictures!

For my next example, I will be using SVG which stands for Scalable Vector Graphics. For more information on it, I highly recommend reading the [specification](https://www.w3.org/TR/SVG11/).

## SVG Checkerboard

```
#include <stdio.h>
int main()
{
 int width=720,height=720;
 int x=0,y=0;
 int index=0,index1=0;
 int rect_width=90,rect_height=90;

 printf("<svg width=\"%d\" height=\"%d\">\n",width,height);

 printf("<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"%d\" style=\"fill:#FFFFFF;\" />\n",x,y,width,height);

 y=0;
 while(y<height)
 {
  index1=index;
  x=0;
  while(x<width)
  {
   if(index==1)
   {
    printf("<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"%d\" style=\"fill:#000000;\" />\n",x,y,rect_width,rect_height);
   }
   index^=1;
   x+=rect_width;
  }
  index=index1^1;
  y+=rect_height;
 }

 printf("</svg>\n");

 return 0;
}

```

The program produces the following code

```
<svg width="720" height="720">
<rect x="0" y="0" width="720" height="720" style="fill:#FFFFFF;" />
<rect x="90" y="0" width="90" height="90" style="fill:#000000;" />
<rect x="270" y="0" width="90" height="90" style="fill:#000000;" />
<rect x="450" y="0" width="90" height="90" style="fill:#000000;" />
<rect x="630" y="0" width="90" height="90" style="fill:#000000;" />
<rect x="0" y="90" width="90" height="90" style="fill:#000000;" />
<rect x="180" y="90" width="90" height="90" style="fill:#000000;" />
<rect x="360" y="90" width="90" height="90" style="fill:#000000;" />
<rect x="540" y="90" width="90" height="90" style="fill:#000000;" />
<rect x="90" y="180" width="90" height="90" style="fill:#000000;" />
<rect x="270" y="180" width="90" height="90" style="fill:#000000;" />
<rect x="450" y="180" width="90" height="90" style="fill:#000000;" />
<rect x="630" y="180" width="90" height="90" style="fill:#000000;" />
<rect x="0" y="270" width="90" height="90" style="fill:#000000;" />
<rect x="180" y="270" width="90" height="90" style="fill:#000000;" />
<rect x="360" y="270" width="90" height="90" style="fill:#000000;" />
<rect x="540" y="270" width="90" height="90" style="fill:#000000;" />
<rect x="90" y="360" width="90" height="90" style="fill:#000000;" />
<rect x="270" y="360" width="90" height="90" style="fill:#000000;" />
<rect x="450" y="360" width="90" height="90" style="fill:#000000;" />
<rect x="630" y="360" width="90" height="90" style="fill:#000000;" />
<rect x="0" y="450" width="90" height="90" style="fill:#000000;" />
<rect x="180" y="450" width="90" height="90" style="fill:#000000;" />
<rect x="360" y="450" width="90" height="90" style="fill:#000000;" />
<rect x="540" y="450" width="90" height="90" style="fill:#000000;" />
<rect x="90" y="540" width="90" height="90" style="fill:#000000;" />
<rect x="270" y="540" width="90" height="90" style="fill:#000000;" />
<rect x="450" y="540" width="90" height="90" style="fill:#000000;" />
<rect x="630" y="540" width="90" height="90" style="fill:#000000;" />
<rect x="0" y="630" width="90" height="90" style="fill:#000000;" />
<rect x="180" y="630" width="90" height="90" style="fill:#000000;" />
<rect x="360" y="630" width="90" height="90" style="fill:#000000;" />
<rect x="540" y="630" width="90" height="90" style="fill:#000000;" />
</svg>
```


There is no mystery as to why it works the way it does. The location, size, and color of each square is a number. If everything is a number and numbers are represented by a text language like SVG to show pictures in a web browser, then we can create pictures with something as simple as printf statements in the C programming language. Of course, you usually have to copy and paste the text into a file and save it with the ".svg" extension for most programs to be able to read it.

The next method I will be using to generate a picture does not use vector graphics at all. Instead, it operates a large array of 32 bit integers as if they were pixels. The following program calls several different functions that I wrote as part of my BBM (Binary Bit Map) project.

## Portable Bitmap Checkerboard

```
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "bbm.h"
int main()
{
 uint32_t *p=NULL; /*The pointer to the pixels*/
 int width=720,height=720; /*The size of the image.*/
 int square_size=90; /*size of each square in the checkerboard that will be created*/
 uint32_t colors[]={0x000000,0xFFFFFF};

 p=BBM_malloc(width,height);

 chastity_checker(p,width,height,square_size,colors[1],colors[0]);

 BBM_SavePBM(p,width,height,"image.pbm");

 BBM_free(p);

 return 0;
}
```

If you take a look at the source, you will see that it includes a file named "bbm.h". This is a small file that I wrote with some utility functions. The BBM project was designed to be an entire library that created pictures of black and white by writing to image files.

To properly run this code, I will also included the source below to the "bbm.h" file and all the functions which are called in the main function from above. If you copy this to a file named "bbm.h" and place it in the same folder as your main source file, it will work correctly.

Don't worry if you don't understand it all right now, it took me months of work to get the formulas for these just right.

```
/*
# Binary Bit Map

This C library file was created for my book, Chastity's Code Cookbook. It demonstrates that it is possible to create image files with only the C standard library.
All code was written entirely with by Chastity White Rose. The design is focused on black and white images only, but the format used for pixels is 32 bit unsigned integers.
This code is therefore extendable to use for any colors if I wish to expand it.
*/

/*
 Allocates memory for the pixels which should be 4 bytes/32 bits per pixel. Uses standard library function malloc.
 uint32_t is a 32 bit unsigned integer type. This is why stdint.h is always included.
 I never need more than 32 bits and any more would waste memory.
*/
uint32_t* BBM_malloc(uint32_t width,uint32_t height)
{
 uint32_t *pointer;
 int length=width*height;
 pointer=(uint32_t*)malloc(length*sizeof(*pointer));
 if(pointer==NULL){printf("Error: malloc failed,\n");}
 return pointer;
}

/*
frees the memory the pointer points to, but only if the pointer is not already NULL.
*/
void BBM_free(uint32_t *pointer)
{
 if(pointer!=NULL){free(pointer);pointer=NULL;}
}

/*
 The function that saves the pixels to a PBM file.
 0 is black and 1 is White.
 Each byte contains 8 pixels. One per bit.
*/
void BBM_SavePBM_Pixels(uint32_t *p,uint32_t width,uint32_t height,FILE* fp)
{
 uint32_t x,y,pixel,r,g,b,gray,bitcount,bits,bpp=1;

 y=0;
 while(y<height)
 {
  bitcount=0;
  bits=0;
  x=0;
  while(x<width)
  {
   pixel=p[x+y*width];
   r=(pixel&0xFF0000)>>16;
   g=(pixel&0x00FF00)>>8;
   b=(pixel&0x0000FF);
   gray=(r+g+b)/3;
   gray>>=8-bpp; gray^=1;
   bits<<=bpp;
   bits|=gray;
   bitcount+=bpp;
   x++;
   while(bitcount>=8)
   {
    fputc(bits,fp);
    bitcount-=8;
   }
  }

  /*If width is not a multiple of 8 pad the bits to a full byte*/
  while(bitcount!=0)
  {
   bits<<=1;
   bitcount++;
   if(bitcount==8)
   {
    fputc(bits,fp);
    bitcount=0;
   }
  }
  y++;
 }

}

/*
Saves to PBM. My favorite already existing format because of it's simplicity. Next to my own BBM format this is the most efficient uncompressed storage of black and white pixels I have seen, unless there is another format I don't know about.
*/
void BBM_SavePBM(uint32_t *p,uint32_t width,uint32_t height,const char* filename)
{
 FILE* fp;
 fp=fopen(filename,"wb+");
 if(fp==NULL){printf("Failed to create file \"%s\".\n",filename); return;}
 else{/*printf("File \"%s\" opened.\n",filename);*/}
 fprintf(fp,"P4\n"); fprintf(fp,"%d %d\n",width,height);

 BBM_SavePBM_Pixels(p,width,height,fp);

 fclose(fp);
 /*printf("Saved to file: %s\n",filename);*/
}

/*
Code for filling the image with a checkerboard. This is my most precious of programming creations!
*/
void chastity_checker(uint32_t *p,uint32_t width,uint32_t height,uint32_t square_size,uint32_t color0,uint32_t color1)
{
 uint32_t x,y=0,index=0,index1,bitcountx,bitcounty=0;
 while(y<height)
 {
  index1=index;
  bitcountx=0;
  x=0;
  while(x<width)
  {
   if(index==0){p[x+y*width]=color0;}
    else       {p[x+y*width]=color1;}
   bitcountx+=1;if(bitcountx==square_size){bitcountx=0;index^=1;}
   x+=1;
  }
  index=index1;
  bitcounty+=1;if(bitcounty==square_size){bitcounty=0;index^=1;}
  y+=1;
 }
}
```

The image file is a PBM (**P**ortable **B**it **Map**). It is a very simple but also well [documented](https://netpbm.sourceforge.net/doc/pbm.html) format. I learned this format so that I can write an array of pixels to a binary file.

Let me briefly explain the function of the various functions.

BBM_malloc allocates memory for the amount of pixels we need. It calls malloc, which is a C standard library function. However, I wrote the functiont automatically print an error message if memory allocation fails.

BBM_free deletes the memory allocation with the C library function free if it points to anything valid.

chastity_checker is the function I am most proud of. It draws a checkboard entirely with some index variables and loops to fill any entire image with a checkerboard. It allows for theoretically using any colors, but in this example, we are outputting to a format that only supports black and white.

BBM_SavePBM does a lot of things. It creates and opens a file, writes the initial header of the format. calls another function I wrote, BBM_SavePBM_Pixels, to actually write the pixels, then closes the file.

Understanding the nature of everything that is in the functions requires knowing on a deep level how to use the bitwise AND, OR, XOR, and left and right bit shifts. Without a working knowledge of the Binary Numeral System, you will not at first understand what is happening here.

However, if you have some understanding of the C library, you will understand the usage of the functions relating to file creation and output.

## Converting the Image File

The PBM file created will not be readable by most programs. You can instead use some other tools to convert it. You can use the graphical image editor GIMP to load and export it to a different format.

However, what I do is use [ImageMagick](https://imagemagick.org/) from the command line.

`magick image.pbm image.png`

The end result is that the image looks like this:

![pbm-checker.png](https://chastitywhiterose.com/wp-content/uploads/2025/07/pbm-checker.png)

You can also achieve the same result with the tool [FFmpeg](https://ffmpeg.org/).

`ffmpeg -i image.pbm image.png`

## Graphics Fundamentals

By now you might be thinking: *"Creating image files to display in other programs is great, but can't I write a program to display a picture without writing it to a write for a different program to view?"*

And it is a very good question. The short answer is yes, but the problem lies with the fact that the C library installed along with the C compiler does not contain anything related to graphics. At the time it was written, computer graphics as we know them today didn't exist.

You might wonder how video games are created using the C and C++ languages all the time. There are two main ways to create graphics directly in a windowed desktop application. There is the hard way and the easy way.


### The Hard Way

The hard way, and for many years the only way, to create a window and draw things onto it is to use the native API for your operating system. I have never learned how to do this because I am only interested in writing software that works on Linux and Windows equally well.

But what is Linux? Linux is an operating system like Windows or MacOS is. However, it is free and open source! Technically Linux is a kernel and the operating system consists of various component, which includes the X Window System and different Desktop Environments.

But if you don't know what Linux is, I am not the best qualified to explain it. However, I have been using Linux for 20 years and I know a thing or two about getting almost any of my C programs compiled on Linux. I can also play Chess on lichess.org just as well on Linux as I can Windows.

The specific version of Linux I use is called Debian. I would suggest you give it a try if you have an old computer that has Windows but is running too slow.

<https://www.debian.org/>

I know that is a lot of information to take in right now but I mention it because programming on Linux is easier than it is on Windows. That is because the built in package manager lets you install SDL directly without even opening up your web browser and visiting the website! For example, on a Debian or Ubuntu based system, this command will install everything you need to get started with my example SDL program in the next section.

`sudo apt-get install libsdl2-dev`

### The Easy Way

The easy way to make graphical applications and video games is to use [SDL](http://www.libsdl.org/). SDL stands for Simple Directmedia Layer. It is a library of functions written by people much smarter than me which act as a layer between what the programmer wants to do and communicating with the operating system to achieve the result.

I will provide you a short sample of a program written with SDL just so you get an idea how it looks. In a later chapter, I will have to walk you through some things that you need to know to install and compile programs written using the library.

## SDL Square Target

```
#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
int main(int argc, char **argv)
{
 int x,y;
 int colors[]={0x000000,0xFFFFFF},index=0;
 int rect_width=30,rect_height=30;
 SDL_Rect rect;

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 /*drawing section begin*/

 rect.w=width;
 rect.h=height;

 x=0;
 y=0;

 while(rect.w>0)
 {
  rect.x=x;
  rect.y=y;
  SDL_FillRect(surface,&rect,colors[index]);
  x+=rect_width;
  y+=rect_height;
  rect.w-=rect_width*2;
  rect.h-=rect_height*2;
  index^=1;
 }

 /*drawing section end*/

 SDL_UpdateWindowSurface(window);

 printf("SDL Program Compiled Correctly\n");

 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }
 }
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
```

On my Debian Linux system, I use this command to compile and run this program.

```
gcc -Wall -ansi -pedantic main.c -o main `sdl2-config --cflags --libs` -lm && ./main
```

When you successfully compile and run the program, it will look something like this!

![sdl-square-target.png](https://chastitywhiterose.com/wp-content/uploads/2025/08/sdl-square-target.png)

If you look at the source code, you will see that it has a lot of code that must be done before we even get to the drawing section that I marked with comments at the beginning and end.

When I first started using SDL version 2, it did not have support for drawing anything other than rectangles. There is an advanced way to do with by alternative means but that is beyond the scope of this book.

However, rectangles are all you need to make an entire Tetris game! I wrote all the code for my own game and published it on Steam.

<https://store.steampowered.com/app/1986120/Chaste_Tris/>

I will admit the code was a complete wreck and the game is not as advanced as the officially licensed Tetris games. However, as a proof of concept, and for the sake of making a video game so I can cross it off my bucket list, I did it.

Before you leave this chapter, I want you to know more than one thing, the square is a special case of a rectangle where the width and height are the same. My obsession with the games Tetris and Chess most certainly is because I am obsessed with the shape of the square! Therefore, all of my graphics programming experience came about from my desire to draw perfect checkerboards on the computer. I have succeeded!

# Chapter 3: Back to Binary Basics

In chapter 1 I showed you my favorite integer sequences and how easy it is to generate them with a bit of math and printf statements in the C Programming Language. However, a lot of the code in my powers of two program and also the Portable Bit Map Checkerboard program do not make sense unless you understand that nature of the binary numeral system. To help illustrate it, I have created a small program which displays the numbers 0 to 15.

## Binary to Decimal Counting 4 Bits

```
#include <stdio.h>
#include "binlib.h"
int main()
{
 int a=0;
 while(a<16)
 {
  printf("%s %02d\n",int_to_binary_string(a,4),a);
  a++;
 }
 return 0;
}
```

The included file "binlib.h" contains this function:

```
#define ulength 100  /*the size of the array to be defined next*/
char u[ulength]; /*universal array for my integer to binary string function*/

char* int_to_binary_string(unsigned int i,int width)
{
 char *s=u+ulength;
 *s=0;
 do
 {
  s--;
  *s=i&1;
  i>>=1;
  *s+='0';
  width--;
 }
 while(i!=0 || width>0);
 return s;
}
```

When run, the program displays this:

```
0000 00
0001 01
0010 02
0011 03
0100 04
0101 05
0110 06
0111 07
1000 08
1001 09
1010 10
1011 11
1100 12
1101 13
1110 14
1111 15
```

The numbers on the left are the binary version and the numbers on the right are the decimal numbers you have been taught all your life by human society. The truth is, there are as many different bases to use for a number system as there are numbers themselves.

By looking at the chart above, you can probably figure out how binary works already, but in case you are stuck, here is another small sample program and its output to drive the point even clearer.

## Left Shift Example

```
#include <stdio.h>
#include "binlib.h"
int main()
{
 int a=1;
 while(a!=0)
 {
  printf("%s %10u\n",int_to_binary_string(a,32),a);
  a<<=1;
 }
 return 0;
}
```

The output of this program is:

```
00000000000000000000000000000001          1
00000000000000000000000000000010          2
00000000000000000000000000000100          4
00000000000000000000000000001000          8
00000000000000000000000000010000         16
00000000000000000000000000100000         32
00000000000000000000000001000000         64
00000000000000000000000010000000        128
00000000000000000000000100000000        256
00000000000000000000001000000000        512
00000000000000000000010000000000       1024
00000000000000000000100000000000       2048
00000000000000000001000000000000       4096
00000000000000000010000000000000       8192
00000000000000000100000000000000      16384
00000000000000001000000000000000      32768
00000000000000010000000000000000      65536
00000000000000100000000000000000     131072
00000000000001000000000000000000     262144
00000000000010000000000000000000     524288
00000000000100000000000000000000    1048576
00000000001000000000000000000000    2097152
00000000010000000000000000000000    4194304
00000000100000000000000000000000    8388608
00000001000000000000000000000000   16777216
00000010000000000000000000000000   33554432
00000100000000000000000000000000   67108864
00001000000000000000000000000000  134217728
00010000000000000000000000000000  268435456
00100000000000000000000000000000  536870912
01000000000000000000000000000000 1073741824
10000000000000000000000000000000 2147483648
```

The binary system works exactly like you would expect given the chart above. Each bit is either 0 (off) or it is a 1 which represents that a specific power of two is turned "on".

For example, add this function to "binlib.h"

```
int binary_string_to_int(char *s)
{
 int i=0;
 char c;
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c == '0' || c == '1' ){c-='0';}
  else if( c == ' ' || c == '\n' || c == '\t' ){return i;}
  else{printf("Error: %c is not a valid character for base 2.\n",c);return i;}
  i<<=1;
  i+=c;
  s++;
 }
 return i;
}
```

And then the following program will display my age!

## Binary Age Example

```
#include <stdio.h>
#include "binlib.h"
int main()
{
 printf("My name is Chastity and I am %d years old!\n",binary_string_to_int("100110"));
 return 0;
}
```

The result is:

`My name is Chastity and I am 38 years old!`

This works because we are literally sending a binary string which represents 32+0+0+4+2+0.

Perhaps you are starting to understand how it works by now. If not, don't worry because technically you don't need to know binary to be a computer programmer. but some advanced techniques in graphics programming are not possible without a working knowledge of how many bits a data type is and how to modify individual bits.

## Why is Binary Used?

But perhaps the larger question is why Binary is used in computers. Basically the idea is that states of on/off or low/hi voltage are how electricity is measured. Once you understand that everything in the world can be represented by a number and that Binary is one such system to represent numbers, you can see why it is so popular in computer hardware and software.

Anyhow, welcome to the art of computer programming, where black and white thinking really does help you! Or perhaps I should say, welcome to autism!

## The Bitwise Operations

There are 5 bitwise operations which operate on the bits of data in a computer. For the purpose of demonstration, it doesn't matter which number the bits represent at the moment. This is because the bits don't have to represent numbers at all but can represent anything described in two states. Bits are commonly used to represent statements that are ***true*** or ***false***. For the purposes of this section, the words AND, OR, XOR are in capital letters because their meaning is only loosely related to the English words they get their name from.

### Bitwise AND Operation

```
0 AND 0 == 0
0 AND 1 == 0	
1 AND 0 == 0
1 AND 1 == 1
```

Think of the bitwise AND operation as multiplication of single bits. 1 times 1 is always 1 but 0 times anything is always 0. That's how I personally think of it. I guess you could say that something is true only if two conditions are true. For example, if I go to Walmart AND do my job then it is true that I get paid.

### Bitwise OR Operation

```
0 OR 0 == 0
0 OR 1 == 1	
1 OR 0 == 1
1 OR 1 == 1
```

The bitwise OR operation can be thought of as something that is true if one or two conditions are true. For example, it is true that playing in the street will result in you dying because you got run over by a car. It is also true that if you live long enough, something else will kill you. Therefore, the bit of your impending death is always 1. 

### Bitwise XOR Operation

```
0 XOR 0 == 0
0 XOR 1 == 1	
1 XOR 0 == 1
1 XOR 1 == 0
```

The bitwise XOR operation is different because it isn't really used much for evaluating true or false. Instead, it is commonly used to invert a bit. For example, if you go back to the source of my graphics programs in Chapter 2, you will see that most of those programs contain the statement: 

**`index^=1;`**

If you look at my XOR chart above, you will see that using XOR of any bit with a 1 causes the result to be the opposite of the original bit. In the context of those programs, the index variable is meant to be 0 to represent black and 1 to represent white. The XOR operation is the quickest way to achieve this bit inversion. In fact, in all my years of programming, that's pretty much the only thing I have used it for!

### Bitwise Left and Right Shift Operations

Consider the case of the following 8 bit value:

00001000

This would of course represent the number 8 because a 1 is in the 8's place value. We can left shift or right shift.

```
00001000 ==  8 : is the original byte

00010000 == 16 : after left shift
00000100 ==  4 : after right shift
```

Left and right shift operations allow us to multiply or divide a number by 2 by taking advantage of the base 2 system. These shifts are essential in graphics programming because sometimes to need to extract the red, green, or blue values separately out of their 24 bit representation. For example, consider this code:

```
   pixel=p[x+y*width];
   r=(pixel&0xFF0000)>>16;
   g=(pixel&0x00FF00)>>8;
   b=(pixel&0x0000FF);
```

The first statement gets the pixel out of an array of data which is indexed by x and y geometric coordinates. This will be a 24 bit value, or in some cases 32 bit with the highest 8 bits representing the alpha or transparency level.

variables r,g,b represent red, green, and blue. With clever use of bitwise AND operations and right shifting by the correct number of bits, it is possible to extract just that color component to be modified. Without the ability to do this, my graphics animations and my Tetris game would never have been possible. The colors had to be exactly sent to the drawing functions. This is true not just for SDL but using any graphical system involving colors.

## Learning More

I know I covered a lot in this chapter but I encourage you to learn about the binary numeral system and its close cousin the hexadecimal system. If you do an online search, you will find courses, tutorials, and videos by millions of people who can probably explain these same concepts in a way that you understand better if you are still confused after reading this chapter!

# Chapter 4: Animation with SDL

At the end of Chapter 2, I shared a small program which creates a target of black and white squares. It was nice but it is also possible to animate it by adding some new variables that change over time. The code below will show you what I mean if you can compile and run it.

## Animation SDL Square Target

```
#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x,y;
 int colors[]={0x000000,0xFFFFFF},index=0,index1=0;
 int rect_width=30,rect_height=30;
 SDL_Rect rect;
 int bitcount;

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 printf("SDL Program Compiled Correctly\n");

 delay=1000/fps;
 bitcount=0;
 index1=0;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  rect.w=width;
  rect.h=height;

  x=0;
  y=0;

  index=index1;
  SDL_FillRect(surface,NULL,colors[index^1]);

  while(rect.w>0)
  {
   rect.x=x+bitcount;
   rect.y=y+bitcount;
   rect.w=width-x*2-bitcount*2;
   rect.h=height-y*2-bitcount*2;
   SDL_FillRect(surface,&rect,colors[index]);
   x+=rect_width;
   y+=rect_height;
   index^=1;
  }

  if(bitcount==rect_width)
  {
   bitcount=0;
   index1^=1;
  }
  bitcount++;

  /*drawing section end*/

  SDL_UpdateWindowSurface(window);

  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  /*time loop used to slow the game down so users can see it*/
  while(loop==1 && sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }

 }
 /*end of loop after user presses escape*/
 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
```
You will notice that I added some time variables. A time loop is used to pause the program long enough for the user to see the frame before the next frame is drawn.

`sdl_time = SDL_GetTicks();`

Will get the current time in milliseconds since the program began.

`sdl_time1 = sdl_time+delay;

Will set a future time by adding the millisecond delay. If the delay were 1000 then it would wait an entire second. However, delay is set to:

`delay=1000/fps;`

Since fps (frames per second) is set to 60, then each frame will last approximately a 60th of a second. Since many modern video formats are 60 fps, this is great for recording with [OBS Studio](https://obsproject.com/).

If you don't feel like copying and pasting the code to create this animation program, I also have a video on YouTube that shows the result of what it looks like!

<https://www.youtube.com/watch?v=e5jo3x57ewI>

## Game: Checkerboard Explorer

The last example was an animation because the picture changed every frame. However the example I will show you now is a very basic game. That is because it accepts user input to change the animation!

As you might have guessed, this game will involve a checkerboard because I am so good at making them. This is a very large program so don't expect to understand it all at first. Making this is a two step process.

First, create a file named "sdl_chaste_checkerboard_surface.h" to be included in the main program. It contains a structure definition and 2 important functions for drawing a checkerboard using the structure.

```
/*
sdl_chaste_checkerboard_surface.h

This file contains my functions for drawing a checkerboard in SDL2 using software surfaces.
*/

struct checkerboard
{
 int x_begin,y_begin,x_end,y_end;
 int rectsize;
 int rectcolor;
};

struct checkerboard main_check;

/*set up initial state to allow drawing checkerboard to whole screen*/
void init_checkerboard()
{
 main_check.x_begin=0;
 main_check.y_begin=0;
 main_check.x_end=width;
 main_check.y_end=height;
 main_check.rectsize=32;
 main_check.rectcolor=0xFFFFFF;
}

/*
 this function draws a checkerboard. it is highly optimized because it does not switch colors during the function. it only draws half of the checkerboard squares and leaves the remaining areas the same as the background
*/
void chaste_checker()
{
 int x,y,index,index1;
 index=0;

 rect.w=main_check.rectsize;
 rect.h=main_check.rectsize;

 y=main_check.y_begin;
 while(y<main_check.y_end)
 {
  index1=index;
  x=main_check.x_begin;
  while(x<main_check.x_end)
  {
   if(index==1)
   {
    rect.x=x;
    rect.y=y;
    /*SDL_RenderFillRect(renderer,&rect);*/
    SDL_FillRect(surface,&rect,main_check.rectcolor);
   }
   index^=1;
   x+=main_check.rectsize;
  }
  index=index1^1;
  y+=main_check.rectsize;
 }

}
```

The checkerboard structure contains the data on where the checkerboard begins and ends. The idea for this was to allow the checkerboard to be drawn to just a part of the window. For this example, though, we are going to fill the entire window with a checkerboard that moves! The following source goes in "main.c" to be compiled along with the included file above.

```
#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
SDL_Rect rect;

#include "sdl_chaste_checkerboard_surface.h"

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x=1,y=1,speed=1;
 int colors[]={0x000000,0xFFFFFF};

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 printf("SDL Program Compiled Correctly\n");

 /*checkerboard intialization section*/

  init_checkerboard();
  main_check.rectcolor=colors[1];
  main_check.rectsize=90;

  main_check.x_begin=0;
  main_check.y_begin=0;

 /*end of checkerboard intialization section*/

 delay=1000/fps;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  SDL_FillRect(surface,NULL,colors[0]);
  chaste_checker();

  /*modification of coordinates begins*/

  main_check.x_begin+=x*speed;
  main_check.y_begin+=y*speed;

  /*modification of coordinates ends*/


 /* bounds checking for animation*/

 if(main_check.x_begin>0)
 {
  main_check.x_begin-=main_check.rectsize*2;
 }

 if(main_check.x_begin<-main_check.rectsize*2)
 {
  main_check.x_begin+=main_check.rectsize*2;
 }

 if(main_check.y_begin>0)
 {
  main_check.y_begin-=main_check.rectsize*2;
 }

 if(main_check.y_begin<-main_check.rectsize*2)
 {
  main_check.y_begin+=main_check.rectsize*2;
 }

 /*end of bounds checking*/
  
  /*drawing section end*/

  SDL_UpdateWindowSurface(window);

  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  /*time loop used to slow the game down so users can see it*/
  while(loop==1 && sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  while(SDL_PollEvent(&e))
  {
   int k;
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}

    /*https://github.com/libsdl-org/SDL/blob/SDL2/include/SDL_keycode.h*/

    /*user input section start*/

    k=e.key.keysym.sym;

    /*rook directions: orthagonal*/
    if(k==SDLK_KP_8||k==SDLK_UP||k==SDLK_w){x=0;y=-1;}
    if(k==SDLK_KP_2||k==SDLK_DOWN||k==SDLK_x){x=0;y=1;}
    if(k==SDLK_KP_4||k==SDLK_LEFT||k==SDLK_a){x=-1;y=0;}
    if(k==SDLK_KP_6||k==SDLK_RIGHT||k==SDLK_d){x=1;y=0;}

    /*bishop directions: diagonal*/
    if(k==SDLK_KP_1||k==SDLK_z){x=-1;y=1;}
    if(k==SDLK_KP_3||k==SDLK_c){x=1;y=1;}
    if(k==SDLK_KP_7||k==SDLK_q){x=-1;y=-1;}
    if(k==SDLK_KP_9||k==SDLK_e){x=1;y=-1;}

    /*stop moving entirely*/
    if(k==SDLK_KP_5||k==SDLK_s){x=0;y=0;}

    /*press t to reset to 0,0 for starting position of the checkerboard and stop all movement*/
    if(k==SDLK_t){x=0;y=0;  main_check.x_begin=0;main_check.y_begin=0;}

    /*press f to move faster*/
    if(k==SDLK_f){speed++;}
    /*press r to reset speed*/
    if(k==SDLK_r){speed=1;}

    /*user input section end*/

   }
  }

 }
 /*end of loop after user presses escape*/
 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
```

In this game, Checkerboard Explorer, you are flying above a massive checkerboard with apparently no end in sight. You can move in different directions by pressing the arrow keys, number pad keys (if your keyboard has them), or using the letters q,w,e,a,s,d,z,x,c to change or stop moving. You can also fly faster by pressing f or reset your speed with r.

At any time you can press t to turn off the animation and reset it to look like a still picture of the checkerboard that looks exactly like it would on a real board used for playing Chess or Checkers. And finally, you can escape by pressing the `Esc` key.

The game doesn't have characters, story, music. or a winning and losing condition. However, all video games follow these steps from a computer programming perspective.

- Draw the current graphics to the screen each frame
- Modify variables that change each frame (time, enemies, animations, etc)
- Check for user input from keyboard (or possibly mouse/controller)
- repeat forever until the user terminates the program

This game may be small and simple, but it is still the largest code sample so far up to this point of the book. It took me a long time to learn how to use the C Programming language and SDL to know how to do all this.

## Animation Polygon Target

As cool as squares are, most people will want to draw shapes other than squares. I have written my own functions for doing this. First, below is the main source file for an animation that I have developed which uses a regular polygon drawing function.


```
#include <stdio.h>
#include <SDL.h>

int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;

SDL_Renderer *renderer = NULL;
#include "sdl_chaste_polygon.h"

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x,y;
 int colors[]={0x000000,0xFFFFFF},index=0,color;
 int radius_change=30;

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 /*create a renderer that can draw to the surface*/
 renderer=SDL_CreateSoftwareRenderer(surface);
 if(renderer==NULL){printf("Renderer could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}

 printf("SDL Program Compiled Correctly\n");

 delay=1000/fps;

/*
  an optional step before the game loop but a very awesome one
  initialize the spinning polygon that will be drawn each frame
 */

 init_polygon();
 main_polygon.radius=height/2;
 main_polygon.sides=3;
 main_polygon.step=1;

 main_polygon.cx=width/2;
 main_polygon.cy=height/2;

 x=0;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  SDL_FillRect(surface,NULL,colors[0]);

 index=0;

 y=height/2; /*save initial radius to y variable*/

 main_polygon.radius=y;

 while(main_polygon.radius>0)
 {
  color=colors[index];
  main_polygon.color.r=(color&0xFF0000)>>16;
  main_polygon.color.g=(color&0x00FF00)>>8;
  main_polygon.color.b=(color&0x0000FF);

  /*show the polygon just for fun*/
  chaste_polygon_draw_star();
  y-=radius_change;
  main_polygon.radius=y-x;
 
  index^=1;  
 }
  main_polygon.radians+=PI/180;

  x++;

  if(x==radius_change*2)
  {
   x=0;
  }

  /*drawing section end*/

  SDL_UpdateWindowSurface(window);

  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  /*time loop used to slow the game down so users can see it*/
  while(loop==1 && sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }

 }
 /*end of loop after user presses escape*/
 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
```

In order to make it work, you will need the contents of the "sdl_chaste_polygon.h" file that was included in the source above. Beware, it is quite large!

```
/*sdl_chaste_polygon.h*/

struct polygon
{
 double cx,cy;
 int sides;
 double radius;
 double radians;
 SDL_Color color;
 int step; /*used only in star polygons of 5 or more sides*/
};

struct polygon main_polygon;



void init_polygon()
{
 main_polygon.cx=width/2;
 main_polygon.cy=height/2;
 main_polygon.sides=3;
 main_polygon.step=2;
 main_polygon.radius=height/2;
 main_polygon.radians=0;

 main_polygon.color.r=255;
 main_polygon.color.g=255;
 main_polygon.color.b=255;
 main_polygon.color.a=255;

}


/*
 this function created because the standard round function did not exist in C until 1999 standard.
 I only use 1989 standard. It is sometimes helpful to round to neared integer when the data type requires it.
 Original source here: https://en.cppreference.com/w/c/numeric/math/round
*/
double chaste_round(double x)
{
 return x<0 ? ceil(x - 0.5) : floor(x + 0.5);
}




/*Define PI the same as M_PI in math.h*/
 #define PI 3.14159265358979323846f

/*these point arrays are temporary and not included in the polygon structure*/
int polygon_xpoints[0x1000],polygon_ypoints[0x1000];


/*
function to get the points of a regular polygon and load them into the above arrays of x and y points
*/
void chaste_polygon_points()
{
 double angle,x,y;
 int i=0;
 while(i<main_polygon.sides)
 {
  angle=2*PI*i/main_polygon.sides+main_polygon.radians;
  x=main_polygon.cx+sin(angle)*main_polygon.radius;
  y=main_polygon.cy-cos(angle)*main_polygon.radius;
  polygon_xpoints[i]=chaste_round(x);
  polygon_ypoints[i]=chaste_round(y);
  i++;
 }
}


/* large array for any possible combination of vertices to make many triangles*/
SDL_Vertex vertices[0x1000];

/*this first function draws a series of triangles to make a convex regular polygon*/
void chaste_polygon_draw()
{
 int i,i1;
 chaste_polygon_points();
 
 vertices[0].color=main_polygon.color;
 vertices[1].color=main_polygon.color;
 vertices[2].color=main_polygon.color;
 
 i=0;
 while(i<main_polygon.sides)
 {
  i1=(i+1)%main_polygon.sides;
  
  /*for each part of this loop,construct a triangle*/
  vertices[0].position.x=polygon_xpoints[i];
  vertices[0].position.y=polygon_ypoints[i];
  vertices[1].position.x=polygon_xpoints[i1];
  vertices[1].position.y=polygon_ypoints[i1];
  vertices[2].position.x=main_polygon.cx;
  vertices[2].position.y=main_polygon.cy;
  
  SDL_RenderGeometry(renderer,NULL,vertices,3,NULL,0);
  
  i++;
 }
 
}







/*
 this first function draws a series of triangles to make any kind of regular polygon
 this includes star polygons by taking into account the step value between points.
*/
void chaste_polygon_draw_star()
{
 int i,i1;
 chaste_polygon_points();
 
 vertices[0].color=main_polygon.color;
 vertices[1].color=main_polygon.color;
 vertices[2].color=main_polygon.color;
 
 i=0;
 while(i<main_polygon.sides)
 {
  i1=(i+main_polygon.step)%main_polygon.sides;
  
  /*for each part of this loop,construct a triangle*/
  vertices[0].position.x=polygon_xpoints[i];
  vertices[0].position.y=polygon_ypoints[i];
  vertices[1].position.x=polygon_xpoints[i1];
  vertices[1].position.y=polygon_ypoints[i1];
  vertices[2].position.x=main_polygon.cx;
  vertices[2].position.y=main_polygon.cy;
  
  SDL_RenderGeometry(renderer,NULL,vertices,3,NULL,0);

  i++;
 }
 
}




/*
 this first function draws a series of lines to make an outline of any regular polygon
 this includes star polygons by taking into account the step value between points.
*/
void chaste_polygon_draw_lines()
{
 int i,i1;
 chaste_polygon_points();
 SDL_SetRenderDrawColor(renderer,main_polygon.color.r,main_polygon.color.g,main_polygon.color.b,255);
 i=0;
 while(i<main_polygon.sides)
 {
  i1=(i+1)%main_polygon.sides;
  SDL_RenderDrawLine(renderer,polygon_xpoints[i], polygon_ypoints[i], polygon_xpoints[i1], polygon_ypoints[i1]);
  i++;
 }
}



/*
 this first function draws a series of lines to make an outline of any regular polygon
 this includes star polygons by taking into account the step value between points.
*/
void chaste_polygon_draw_star_lines()
{
 int i,i1;
 chaste_polygon_points();
 SDL_SetRenderDrawColor(renderer,main_polygon.color.r,main_polygon.color.g,main_polygon.color.b,255);
 i=0;
 while(i<main_polygon.sides)
 {
  i1=(i+main_polygon.step)%main_polygon.sides;
  SDL_RenderDrawLine(renderer,polygon_xpoints[i], polygon_ypoints[i], polygon_xpoints[i1], polygon_ypoints[i1]);
  i++;
 }
}
```

The exact math of how the regular polygons are constructed is beyond my ability to explain in a book format. However, I can tell you that the secret is in the function [SDL_RenderGeometry](https://wiki.libsdl.org/SDL2/SDL_RenderGeometry). It allows the programmer to arbitrarily draw any number of triangles by setting up a list of vertices (the plural of vertex). Each vertex contains both a point (x and y geometric coordinates in 2 dimensional space), and a color.

To draw a triangle, the simplest possible polygon, you need at lease 3 vertices. My main source and header above make use of this function to draw many triangles that make up one big triangle!

![sdl-triangle-target.png](https://chastitywhiterose.com/wp-content/uploads/2025/08/sdl-triangle-target.png)

If you can compile and run the source above, you can actually see these triangles spin as the rotation angle changes each frame. You can even change the number of sides, color, or something else, depending on how well you can understand the code!

# Chapter 5: Development Environment

One of the hardest barriers to programming in C or C++ is that setting up a development environment for programming is not easy for beginners. Over the years I have managed to write and compile my programs on various flavors of Linux (Debian, Ubuntu, Puppy, Gentoo) as well as on Windows (98, XP, 8, 10, 11).

However doing so comes only if you know the right information on these things.

- What tools you need to download
- How to install them (and what installing actually means)
- What commands to type for compiling and running
- Where to go for help when you get stuck.

## Tool 1: C Compiler

For the purposes of this book, I am promoting the C Programming Language. This means that you will need a C compiler. The one I recommend is [GCC](https://gcc.gnu.org/) which stands for "GNU Compiler Collection". Of all the existing C compilers there are, I recommend this one because it is [Free and Open Source Software](https://www.gnu.org/philosophy/free-software-even-more-important.html).

Free Software in this context means that the user has control over the program, even to the point of modifying the source code. This level of control only applies to computer programmers smart enough to do so, but it is an important freedom.

## Tool 2: Simple DirectMedia Layer

Another important tool that you will need for some of my examples in this book is the [SDL](http://www.libsdl.org/) library. This library is essential for making video games. It is not the only library for this purpose but I have the most experience using it. I once even made a game called [Chaste Tris](https://store.steampowered.com/app/1986120/Chaste_Tris/) which is basically Tetris without any gravity.

SDL is what I recommend in this book but I will briefly mention that other libraries such as [Allegro](https://liballeg.org/), [Raylib](https://www.raylib.com/), and [SFML](https://www.sfml-dev.org/) can do the same tasks of creating a window, drawing graphics, and handling user input.

## Tool 3: A Text Editor

There are more text editors than you can imagine. For the most part, you can use Notepad on Windows or gedit, mousepad, kate, or any other tool you choose. I honestly never gave it much thought which text editor I use before because I usually use the one provided by the operating system. 

If you are a Windows user, I recommend [Notepad++](https://notepad-plus-plus.org/) because it has syntax highlighting for multiple programming languages. Sometimes having programming elements such as types, numbers, variables, and functions can be extremely helpful.

If you are using Linux, I recommend [SciTE](https://www.scintilla.org/SciTE.html) because it is highly customizable. All of its configuration files are plain text that can be edited if you take the time to experiment.

## Installing Development Tools on Linux

Installing the required compiler and SDL libraries on a Debian or Ubuntu system is trivial and can be done with the following commands if you have your root password from when you installed the operating system.

`sudo apt install gcc`

`sudo apt install libsdl2-dev`

If I use other Linux distributions in the future, I will probably add more information on how to install these tools on them. However, Debian based distributions are extremely popular and those commands or something similar will work 90% of the time unless you are using something like Arch, Gentoo, or a PC without an internet connection.

Most of the time the user of Linux is the one who installed the operating system. Contrary to what most Linux users say, I will admit that Linux is not for everyone because it requires being comfortable with running commands in a terminal and diagnosing error messages.

Anyone who wants to be a computer programmer must be willing to make the required sacrifice during the Linux learning curve. Linux is not like Windows where you can point and click your way with a mouse (well, actually it is but then it depends on which desktop environment you have installed). Most of the time, you can google which commands are relevant to your platform or programming language you are trying to find a compiler or interpreter for.

If you are installing SciTE, you can also do that with:

`sudo apt install scite`

### Testing the Tools on Linux

If GCC is installed correctly, you can run this command to check which version you have.

`gcc --version`

On my system, the result I get is:

```
gcc (Debian 12.2.0-14+deb12u1) 12.2.0
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

Similarly, you can test whether SDL2 is installed with this command.

`sdl2-config --version`

On my system, I get "2.26.5" as the result. The exact version number doesn't matter that much since all examples will will work with any version 2 or higher.

Next, compile a small program that does nothing except make a window, fill it with magenta, and close when the user presses escape.

```
#include <stdio.h>
#include <SDL.h>
int width=1280,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
int main(int argc, char **argv)
{
 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/
 SDL_FillRect(surface,NULL,0xFF00FF);
 SDL_UpdateWindowSurface(window);
 printf("SDL Program Compiled Correctly\n");
 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }
 }
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
```

The command I use to compile my program is the following

```
gcc -Wall -ansi -pedantic main.c -o main `sdl2-config --cflags --libs` -lm && ./main
```

Technically you can drop the "`-Wall -ansi -pedantic`" flags. They just enforce very strict compliance to the C standard defined in 1989. The following will work just as well.

```
gcc main.c -o main `sdl2-config --cflags --libs` -lm && ./main
```

If it works, you will see the window and can close it by pressing escape or clicking the X in the corner.

The part with the sdl2-config script is very important. It is used to help add the required flags used to tell the compiler where the include files are and where the linkable compiled libraries are which contain the functions the include files are pointing to. If I run this command on my Linux system:

`sdl2-config --cflags --libs`

Then I get the result:

```
-I/usr/include/SDL2 -D_REENTRANT
-lSDL2
```

The "/usr/include/SDL2" folder is where the included files for SDL are found on my system. Each Linux system may have them in a different place. If you are on Windows then they certainly won't be at that spot. The developers of SDL have made the sdl2-config script to handle this so that code can be made more portably.

## Installing Development Tools on Windows

Programming on Microsoft Windows is much harder than on Linux because most of the books out there have instructions for installing and using Microsoft Visual Studio. For the purpose of this book, I recommend not using an IDE (Integrated Development Environment) because it hides details of the compilation process that I am trying to teach. Compiling from the command line allows greater control of the process than using an IDE.

Also, each IDE will have many menu options that differ and then you have to memorize how to navigate them each time you switch to a new program or the same program is updated and you can't figure it out. In fact, Microsoft is known for changing their software to be harder to use with new versions.


Instead, I will recommend a software kit developed by [skeeto](https://github.com/skeeto) on github which is a convenient way to get a working copy of GCC and other useful tools that may assist you in programming on Windows.

By downloading [w64devkit](https://github.com/skeeto/w64devkit), you get [Mingw-w64 GCC](https://www.mingw-w64.org/), [GNU Make](https://www.gnu.org/software/make/), and [busybox](https://frippery.org/busybox/). These tools will allow you to compile and run C programs, run advanced tasks with makefiles for GNU Make, and run most Linux commands (ls, cat, etc).

The reason I recommend it is because it allows you to develop any program exactly the way you would on Linux without having to install Linux. Most people don't use Linux unless they are already into programming. If you are getting your start with C programming and your computer has Windows, then you will benefit from this section.

Step 1: Download w64devkit

Go to the repository here and go to the releases page. You will find several releases. You will be fine going with the latest version, whichever it is.

<https://github.com/skeeto/w64devkit/releases>

The files with "x64" in their name refer to the modern Windows version that run on 64 bit processors (usually this means Windows 7, 8 , 10,or 11). Most of the time, this is what you want.

At the time of this writing, the latest version of w64devkit is [2.4.0](https://github.com/skeeto/w64devkit/releases/tag/v2.4.0). This means that the file to download is:

`w64devkit-x64-2.4.0.7z.exe`

Run the executable and it will allow you to extract the files into their full folder. Inside will be a file named:

`w64devkit.exe`

If you run it, you will be inside a little environment which operates a lot like Linux. You can run gcc and compile the same way you would in Linux.

### Testing the Tools on Windows

Once inside the mini environment of w64devkit, create a folder to start working in.

`mkdir test`

Change to that folder.

`cd test`

Open your preferred text editor and create the following file named "hello.c".

```
#include <stdio.h>
int main()
{
 printf("Hello, World!\n");
 return 0;
}

```

Then run this command to compile and run it!

`gcc -Wall -ansi -pedantic hello.c -o hello && ./hello`

### Using SDL with w64devkit

By default while using w64devkit, you can only compile and run programs that use the standard C library. However, now that you have a working environment, you can install the SDL library into it as well for all the SDL programs I have included in this book.

Download the latest SDL release here:

<https://github.com/libsdl-org/SDL/releases/latest>

As of this writing, the version is [3.2.20](https://github.com/libsdl-org/SDL/releases/tag/release-3.2.20).
You will need the file that includes both "devel" and mingw in its name. For example:

`SDL3-devel-3.2.20-mingw.zip`

After extracting the zip, find the "x86_64-w64-mingw32" folder. Inside this are 4 folders.

Copy the folders (bin, include, lib, share) into the same folder where you installed w64devkit. If done correctly, then the "SDL3.dll" will be in the bin folder just like gcc is.

Version 3 of SDL is slightly different than what I am used to. There is a migration guide for those like me who are using version 2.

<https://wiki.libsdl.org/SDL3/README-migration>

I have followed this guide made a small example program that compiles with SDL version 3. Copy the following source and save it as "sdl3-test.c".


```
#include <stdio.h>
#include <SDL.h>
int width=1280,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
int main(int argc, char **argv)
{
 if(!SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",width,height,0);
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/
 SDL_FillSurfaceRect(surface,NULL,0xFF00FF);
 SDL_UpdateWindowSurface(window);
 printf("SDL Program Compiled Correctly\n");
 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_EVENT_QUIT){loop=0;}
   if(e.type == SDL_EVENT_KEY_UP)
   {
    if(e.key.key==SDLK_ESCAPE){loop=0;}
   }
  }
 }
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
```

### Running from regular Windows Command line:

It is possible to use w64devkit without running the w64devkit executable. All you need to do is change your path so that when you run commands like gcc, your computer will know where to look for the compiler and libraries.

For example, navigate to the folder containing your source code of what you want to compile. Open a terminal there and enter these commands. Change the path to wherever you have extracted w64devkit to.


```
PATH=C:/w64devkit/bin
echo %PATH%
```

These commands change the path and confirm the path is changed within Windows. By doing this, any other versions of gcc that are installed on Windows will not accidentally be activated.

Finally, to compile and run the sdl3-test program, run the command:

```
gcc -Wall -ansi -pedantic sdl3-test.c -o sdl3-test -IC:/w64devkit/include/SDL3 -lSDL3 && sdl3-test
```

If all the steps are required, you will get a pink window that closes when you press escape or click the X in the upper right corner.

## Notes About SDL Versions

During my lifetime, I have witnessed the evolution of the SDL library. It has been used for many games. When I first started it, the SDL version 1 API (Application Programming Interface) was in common use. Then SDL2 came out and it was faster and had a lot more features.

I used SDL2 for many years during the time it was in common use. When I started writing this book, the examples I wrote used the version 2 API. This leads to a compatibility problem for me as an author.

Do I learn and update all my programs to use version 3? No, because if I do, then versions 4, 5, 6, and beyond will eventually be released and then they will probably once again change the names of functions or the number of arguments.

For example, in the "SDL_CreateWindow" function of SDL3, it is no longer necessary to specify arguments for the Window position. Personally, I think this is a good change because it makes the code look better. However, it does make my SDL2 code invalid when trying to compile with SDL3.

Also, the "SDL_Init" function and several others was changed. Instead of returning true on error and false on success, they now return true on success and false on error. That is why a ! was inserted the the SDL3 test program before "SDL_Init". The ! operator inverts the value of any true/false conditional statement.

By tradition of the C Programming Language, 0 is considered false and any other number is considered true. It is important to remember that this does not apply to all programming languages though.

Also, because SDL functions are written by real humans who have their own tastes, the behavior of functions might change from time to time. I personally find this very frustrating because it causes old code to break and not compile any more.

I would also like to take this moment to explain why the "-Wall -ansi -pedantic" flags are included in some of my compile commands. These flags cause my code to fail if it does not comply with the 1989 standard of the C Programming Language. Yes, there are different versions of the C Programming Language. The ANSI or 1989 standard is my preferred version because I like old things. However, don't let my preference dictate the standard your programs use.

Sometimes change is good. After all, when I first started using Linux, I wasn't very good at it, but now I have come to love it better than I did MS-DOS or Windows 98 (yes, Windows 98 was my favorite version of Windows that I had the pleasure of using).

Besides that, I am transgender, so I know what it's like to go through some changes! That is why I wanted to clarify this chapter and explain that some of my code may no longer work by the time that you are reading this book.

I also have some advice for new devlopers who want to start making video games with SDL. I think that you should learn the latest version because it is usually faster, has more tutorials, and generally will be expected to work on computers longer.

At this time, there is little information on the last version of SDL1. Specifically, 1.2 was the last release in 2012.

<https://github.com/libsdl-org/SDL-1.2>

Even the developers say that you should not use this version for new projects. However, versions 2 and 3 are both receiving updates. If you go to the releases page, you will find that they explain what was changed in each update. Most of it is fixing bugs that were discovered.

<https://github.com/libsdl-org/SDL/releases>

Right now, it is perfectly reasonable to expect that new games be written in SDL 3. If you have already published a game that uses SDL 1 or 2, it will still continue to run for users. All this fuss over versions and changes in the name of functions is only something programmers have to worry about.

## Recommended Versions

These are the versons of SDL that I recommend using to compile the programs in this book. Most of them will use version SDL2 but I may introduce more SDL3 samples either in the book or as a bonus on the official Github repository which will accompany this book.

<https://github.com/libsdl-org/SDL/releases/tag/release-2.32.8>

<https://github.com/libsdl-org/SDL/releases/tag/release-3.2.20>

Keeping up to date with the changes in technology is a full time job itself. However, it is easier when you are using the C Programming Language because it doesn't change as often as Java, Python, Lua, or JavaScript change.

In the next chapter, I will be taking a break from C and instead introduce the concept of shell scripting and how it can be a fun way to explore programming without having to install something that isn't already on your computer! But before that, I will explain how to get SDL version 2 installed alongside version 3.

## SDL Version 2 on Windows

Using the first link above in this section, download the file

`SDL2-devel-2.32.8-mingw.zip`

After extracting the zip, find the "x86_64-w64-mingw32" folder. Inside this are 4 folders.

Copy the folders (bin, include, lib, share) into the same folder where you installed w64devkit. If done correctly, then the "SDL2.dll" will be in the bin folder just like gcc is.

Set the path to the place where w64devkit is installed.

```
PATH=C:/w64devkit/bin
echo %PATH%
```

Now you are ready to run the big command which compiles and links everything needed to get an SDL2 program running. For example:

`gcc -Wall -ansi -pedantic sdl2-test.c -o sdl2-test -IC:/w64devkit/include/SDL2 -Dmain=SDL_main -LC:/w64devkit/lib -lmingw32 -lSDL2main -lSDL2 && sdl2-test`

Note that unlike in Linux, where we have access to the "sdl2-config", these instructions were for compiling from within the default shell on Windows. This is also sometimes called "cmd.exe".

One final note: Although C is promoted as a portable programming language, and it is, I have had a lot of frustration when compiling things using Windows. Although this development environment as described here works on my laptop with Windows 11, I can never trust Windows as a development environment in general, especially for beginners. You can expect different Linux distributions to mostly work the same even if sometimes the package managers or desktop environments differ. Windows breaks compatibility a lot. Who is to say whether Windows 12 and beyond will still work with this method.

When I graduated from Full Sail, I stopped using my Windows 11 laptop because everything I do (writing books, playing Chess and Tetris, and checking email) can be done just the same from Linux on my desktop PC which is older and yet boots up Debian Linux faster than Windows loads on the laptop.

Anyone taking programming seriously should consider the convenience of using Linux and being able to install anything you desire with a package manager so that you don't have to solve a little problem programmers call "dependency hell".

The next chapter will be entirely about shell scripting on Linux. If you are not interested in using Linux, skip it entirely because scripting and automating tasks is where Linux really shines and is one of the main reasons I fell in love with the Linux operating system and how it works.

# Chapter 6: Bash Scripting

As much as I love the C Programming Language, I have to admit that it is not the most beginner friendly. This is because there are so many concepts that must be introduced all at the same time. In this chapter, I am going to introduce small example programs which are all scripts for the Bash (Bourne Again SHell).

[Bash](https://www.gnu.org/software/bash/manual/bash.html) is a command interpreter or the default shell on most Linux systems. It is worth mentioning that you can also use it on Windows if you installed w64devkit according to my instructions in chapter 5. However, Bash is native to Linux and is where most people need to know it.

Rather that going on about what a shell is and the subtle differences between compiled and interpreted languages, I am going to just give an example code.

## Bash Count Script

First, copy this text into a file named "main.sh".

```
#!/bin/bash
declare -i  x y
x=0;y=16
while [ $x -lt $y ]
do
 echo $x
 x=x+1
done
```

Next, run the following command from the terminal:

`chmod +x main.sh`

This will add execute permissions to the script. Next, run the script the same way you would run an executable file.

`./main.sh`

You will see the numbers 0 to 15 printed because the above bash script is a program which counts starting from 0 and prints while the $x variable is less than 16. It is roughly the same as the counting example written in C included in chapter 1.

## Bash Powers of 2

```
#!/bin/bash
declare -i a b c
a=0;
b=32;
c=1;
while [ $a -le $b ]
do
 echo "2 ^ $a = $c";
 a=a+1;
 c=c+c;
done
```

This prints the powers of two using the same basic methods as the chapter 1 C example.

## Bash Prime Finder

```
 #!/bin/bash
 declare -i x y length;
 length=1000
 declare -ai c #declare array of integers

 x=0;
 while [ $x -lt $length ]
 do
  c[x]=0;
  x=x+1;
 done
 c[0]=1;

 echo 2;

 x=3;
 while [ $x -lt $length ]
 do
  echo $x;
  y=x;
  while [ $y -lt $length ]
  do
   c[y]=1;
   y=y+x;
  done
  while [ $x -lt $length ] &&  [ ${c[$x]} -gt 0 ]
  do
   x=x+2
  done
 done
 ```
 
The prime finder will be a lot slower than the same program written in C. However, for the primes less than 1000, you probably won't see the speed difference. Another aspect of the prime finder that is important is that it shows Bash supports arrays. Older shells, including the original Bourne Shell did not include the ability to define arrays or use them in any way. 

Now you might be wondering: "what is the big deal with integer sequences? Can I do something actually useful with Bash?" The answer is of course yes! These are only examples to introduce the language.

Keep in mind, when using Bash, there is no limited standard library because every command/program installed on your machine is a valid command as far as a shell like Bash is concerned!

## Using Bash to build a Website

This book is written in Markdown and I commonly use the program "pandoc" to convert documents to HTML for websites. This is because Markdown takes less time to write than HTML does.

You can use bash to create any type of text document inside a script, for example, consider the following script which will create a directory named "public" and create two markdown files inside it.

```
#!/bin/bash

mkdir -p public

cat > public/index.md << EOF
# Home Page

Welcome to the home page of my website! There is not much here but you can learn more [about me](about.html).
EOF

cat > public/about.md << EOF
# About Me

One thing you should know about me is that I prefer computers over people because they operate correctly most of the time, and even when they don't, I can buy a replacement. This is why I have two computers and no friends.

Go back to [home page](index.html).
EOF

```

That script works with the [heredoc syntax](https://sysxplore.com/heredocs-in-bash/) which is native to bash. This means that one script can create multiple files by redirecting multiline strings to standard input and then redirecting output to the name of a file.

The previous script created two markdown files but it did not convert them to HTML. The next script completes the process.

For this next example, I will show you the bash script which converts all the Markdown files in the "public" directory to HTML with pandoc. You will need to install pandoc for it to actually work on your machine, but this is not very hard to do compared to the development tools described in chapter 5.

```
#!/bin/bash

echo "Converting all Markdown files in public directory to html with pandoc"

for file in public/*.md;
do

command="pandoc ${file} -o ${file%.*}.html -s --quiet"
echo $command
$command

done
```

By using those two scripts, or even theoretically combining them into one, you can write all the pages of a website in Markdown and convert them to HTML. In this case pandoc was used because it is the best conversion program I know about.

But wait, if it is possible to create any text file and also run any program within a Bash shell, wouldn't it be possible to create, compile, and run a C program all inside a bash script? The answer is: yes! In fact I will show to how it is done!

```
#!/bin/bash

cat > main.c << EOF
#include <stdio.h>
int main()
{
 printf("Hello, Linux Shell!\n");
 return 0;
}
EOF

gcc -Wall -ansi -pedantic main.c -o main && ./main
```

Since Bash is the Linux shell, any command that you could run, including the compiler or interpreter of ANY programming language can be executed. Therefore, becoming a master of the Bash shell enables you to write websites or applications that use multple tools and/or programming languages.

In fact, the power of Bash comes from the fact that it places no limitations on what you can do. I am not a master at Bash but I know enough to achieve some basic tasks like I have represented in this chapter. I have purchased e-books and read online documentation to find out exactly what I need to know.

## Bash References

The following links are very helpful when trying to figure out how to do a specific task using Bash.

<https://www.gnu.org/software/bash/manual/bash.html>

<https://tldp.org/LDP/abs/html/abs-guide.html>

# Chapter 7: Web Development

So far in this book, I have shown examples of creating compiled programs with the C Programming Language. I even showed a few examples of using SDL in combination with C to make graphical animations or games. These kinds of programs compile to machine code and run faster than anything else because they are run by the CPU (Central Processing Unit) directly. Most video games are written in C or C++ because of the speed of execution, even though writing the programs can take a long time.

In chapter 6, I showed a few examples of Bash scripting. Bash is an interpreted language. What this means is that the Bash program itself was written in C but that it inteprets the scripts from within it rather than needing to compile them. This is slower but it is best for small scripts that don't require the same speed as C. For example, a script which backs up files or converts them to another format doesn't need to be fast because it is not done 60 times per second like a video game written in C would.

But in this chapter, I am going to introduce the concept of web development using HTML, CSS, and JavaScript. This introduction will be very basic because I am not an expert in this. However, creating small websites using these languages is not very hard compared to writing programs with C or Bash. In fact, that's because you are not writing programs so much as you are writing description languages for how some kind of text, link, or image should look like. This will all make sense once you see some examples. Copy the following text and save it as an HTML file (.html extension).

## Web Page Example

```
<!DOCTYPE html>
<html>
<head>
<title>Web Page Example by Chastity White Rose</title>
</head>
<body>
<h1 id="this-is-a-web-page">This is a Web Page</h1>
<p>This is a small example of what a one page website can look like. Text can also be <em>italic</em>, <strong>bold</strong>, or
<strong><em>even a combination of both</em></strong>. A
website can contain links to other pages or websites. For example, below
is a link to one of my YouTube videos.</p>
<p><a href="https://www.youtube.com/watch?v=1CLDbnesnEg">Chaste Chess:
Undo Feature Added</a></p>
<p>Even pictures can be included in a web page.</p>
<img
src="https://chastitychesschallenge.com/wp-content/uploads/2025/03/chess_start.png"
alt="chess_start.png" />
</body>
</html>
```

That example uses just enough HTML tags to show some of the capability that is most important for the web. Text, images, and links are mostly what websites are built with. You can open it with Firefox, Google Chrome, and many other browsers. It is not that fancy and should work with everything.

Most web browsers will display the page as black text on a white background. This is similar to a paperback book with white paper and black ink. But what if we wanted to reverse the colors and then also make the text bigger and easier to read? For that we can use just a little bit of CSS. See the edited example below where I added the style into the head section.

## Reverse Colors Web Page Example

```
<!DOCTYPE html>
<html>
<head>
<title>Reverse Colors Web Page Example by Chastity White Rose</title>
<style>
	html
	{
	font-size: 40px;
	color: #ffffff;
	background-color: #000000;
	}
</style>
</head>
<body>
<h1 id="this-is-a-web-page">This is a Web Page</h1>
<p>This is a small example of what a one page website can look like. Text can also be <em>italic</em>, <strong>bold</strong>, or
<strong><em>even a combination of both</em></strong>. A
website can contain links to other pages or websites. For example, below
is a link to one of my YouTube videos.</p>
<p><a href="https://www.youtube.com/watch?v=1CLDbnesnEg">Chaste Chess:
Undo Feature Added</a></p>
<p>Even pictures can be included in a web page.</p>
<img
src="https://chastitychesschallenge.com/wp-content/uploads/2025/03/chess_start.png"
alt="chess_start.png" />
</body>
</html>
```

CSS is the modern way of changing the style of text and images on the page, but let me tell you, back in the 90s it was not that way and there were much harder and time consuming methods used to modify the color of text per element. Because of this, HTML got a bad reputation for being hard to write, but really it's not so bad, if you are a complete nerd with no social life like I am!

JavaScript is another language which fits into the mix of HTML and CSS for making web pages easier to navigate. However, I must warn you, JavaScript is powerful and is sometimes used for evil. Some people disable JavaScript in their browser settings because it is used to load all kinds of advertisements that ruin the experience.

But JavaScript is as powerful as C or Bash is as a programming language. However, there are some restrictions placed on it when run as part of a web page.

- JavaScript can't create or delete files on your computer nor run programs on your computer the same way a Bash script can. It is meant to be used only within the context of the web browser. When you close Google Chrome or whatever you use, the HTML, CSS, and JavaScript should all cease. Consider it a small jail where it can't harm the rest of your computer. Personally I am glad for this because I am not a very good JavaScript programmer and I would not want to accidentally do something stupid!

In fact, this makes JavaScript a great first programming language if you are new to the idea of computer programming.

To introduce JavaScript and white it might be helpful, I will use an example script which displays the square numbers. I will explain the meaning of the square numbers later after you see the sequence.

## Square Numbers Demo 1

```
<!DOCTYPE html>
<html>
<head>
<title>Square Numbers Demo 1</title>
</head>
<body>
<h1>The Square Numbers Sequence</h1>

<p id="main">This is the main paragraph!</p>

<script>

var s=""
var a=0,b=1,c=0;

while(a<=16)
{
 s+=c+" ";
 a++;
 c+=b;
 b+=2;
}

document.getElementById("main").innerHTML = s;

</script>

</body>
</html>
```

If you open that web page, you will see the number sequence

	0 1 4 9 16 25 36 49 64 81 100 121 144 169 196 225 256

The [square numbers](https://en.wikipedia.org/wiki/Square_number) are the integers that are the perfect square of each integer. For example, 5 rows of 5 objects can be used to form a square of those objects. There would be 25 total objects. Notice that my code does not use multiplication to multiply the numbers by themselves. Instead, I used the pattern of addition because if you just start at 0 and keep adding the next odd integer (1,3,5,7, etc) then you will get the next square number without the need for multiplication.

But as far as the JavaScript code in the above example, there is actually a lot happening. I defined a paragraph with an id of "main". The text in the paragraph said "This is the main paragraph!". Chances are, if you actually loaded this script, you never saw this message because it was overwritten by the script.

### How does the script work?

First, we define a variable named "s" which is short for string. We set it to "" which is an empty string.

Then we define variables a,b,and c which are integers. Notices that all the variables are defined with the "var" keyword. This is because JavaScript knows the type of variables by what you set them equal to. It knows that s is a string because of the quotes in the assignment. Since a, b, and c are set to integers, they are understood as integers and can be used in arithmetic assignments exactly as you would see in a C program.

Finally, each time the loop goes, the integer c variable is appended to the s string as well as a space. The result is that the string builds all the numbers and then later is assigned to the main paragraph.

Pay close attention to the **document.getElementById** function. It is used to access an element by using the id of an HTML element. That means that as the programmer, you are responsible for setting the correct id in the HTML as well as the JavaScript code.

There is one problem with the script above. Because the user can't see the initial value of the paragraph, wouldn't it be neat if there was a way to see it and then execute the script when the user clicks a button? Actually there is! See the next example!

## Square Numbers Demo 2

```
<!DOCTYPE html>
<html>
<head>
<title>Square Numbers Demo 2</title>

<script>

function square_numbers()
{
 var s=""
 var a=0,b=1,c=0;

 while(a<=16)
 {
  s+=c+" ";
  a++;
  c+=b;
  b+=2;
 }

 document.getElementById("main").innerHTML = s;
}

</script>

</head>
<body>
<h1>The Square Numbers Sequence</h1>

<p id="main">This is the main paragraph!</p>

<button type="button" onclick="square_numbers()">Click this button, I dare you!</button>

</body>
</html>
```

## Code in the "head" vs the "body"

In demo 1, the script was part of the body and was placed after the main paragraph. It overwrote the paragraph before anyone could see it. In demo 2, the script was in the head of the document and defined as a function.

The second method of defining functions in the head of the HTML document is the same way as is usually done in C. We define functions that will be called later, and not necessarily in a linear order. The second method is better for pages that expect the user to click something. The first method is fine when we are just trying to confirm that JavaScript is working by seeing some output.

By now you might be wondering, what is the point of outputting a bunch of numbers and text? Can't we already do that faster with the C or Bash languages? The answer is yes, there are already better methods for such simple examples, but this is only the beginning! JavaScript is also capable of creating graphics using the canvas element! The next example is not just a demo but is a full web application contained in a single page which lets the user create any size of checkerboard they want depending on how they fill out the numbers in the text fields before clicking a button.

## Chastity's JavaScript Checkerboard

```
<!DOCTYPE html>
<html>
<head>
<title>Chastity's JavaScript Checkerboard</title>
<script>

function chastity_checker()
{

//this gets the data from the text
var rows    = parseInt( document.getElementById("text_rows").value );
var columns = parseInt( document.getElementById("text_columns").value );
var scale   = parseInt( document.getElementById("text_scale").value );

document.getElementById("p").innerHTML='<canvas id="canvas" width="0" height="0" ">Your browser does not support the HTML5 canvas tag.</canvas>';
var c=document.getElementById("canvas");

c.width=rows*scale;
c.height=columns*scale;

var ctx=c.getContext("2d");

var colors=new Array("#000000","#FFFFFF");
//var colors=new Array("#FF0000","#00FF00","#0000FF");
//var colors=new Array("#FF0000","#FFFF00","#00FF00","#00FFFF","#0000FF","#FF00FF");

var i=0;
var x=0;
while(x<c.width)
{
 var i1=i;i=(i+1)%colors.length;
 var y=0;
 while(y<c.height)
 {
  ctx.fillStyle=colors[i1];i1=(i1+1)%colors.length;
  ctx.fillRect(x,y,scale,scale);
  y+=scale;
 }
 
 x+=scale;
}

 return;
}

</script>
</head>
<body>

<h1>Chastity's JavaScript Checkerboard</h1>
<p id="p">Enter the integers of your choice and then click the button below to run! You can define how many rows and columns are in this checkerboard and also how large in pixels each one is by changing the scale!</p>

<input type="text" id="text_rows" value="8" > rows<br>
<input type="text" id="text_columns" value="8" > columns<br>
<input type="text" id="text_scale" value="90" > scale<br>
<button type="button" onclick="chastity_checker()">make checkerboard</button><br>

</body>
</html>
```

Fun fact, that checkerboard making web page was actually created in the year 2013. I used to write a lot of JavaScript but forgot most of it. Luckily I have books I bought to remind me how to do the things I have forgotten.

The fact that the modern web browsers support the canvas element allows images to be arbitrarily created inside web pages based on user input. This means that theoretically, JavaScript can be used to make games that play in a web browser. I am not that skilled yet but the potential is there.

# Chapter 8: Big Numbers

Most of the time, the default 32-bit or 64-bit integer size of your cpu is enough to represent most numbers you would use in actual programs. However, some people are math nerds obsessed with extremely large numbers. Some people want thousands or even millions of digits. The complexity involved in generating these numbers might scare you if you don't know how they work.

However, these methods are based on the same way I do addition or multiplication with paper and pencil as I was taught by school books as a child. I have no idea what they are teaching kids in school these days, and even my mother was not the one who taught me math. I had a natural gift at arithmetic that works well in my computer programming today. Every number is in fact an array of digits.

In chapter 1, the "Advanced Powers of Two" program showed my method for displaying powers of two by using arrays of bytes as if they were decimal digits. In this chapter, I will be presenting a modified version of this same program which allocates memory on the heap using the C malloc function. This may not be that essential for a simple program like this, but keep in mind that this is the "proper" way to create arrays in C when you intent to have arrays of millions of bytes. Your computer needs to have a way of stopping if there is not enough memory in the system.

After that, I will also be presenting more programs which generate large numbers quickly. All of these use only the standard C library and my own math routines. Therefore, they work on any C compiler and can also easily be translated to any programming language.

## Big Number Powers of Two

```
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;


 char *a;
 int alength=1,x,y;

 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}

 x=0;
 while(x<length)
 {
  a[x]=0;
  x++;
 }
 a[0]=1;

 while(alength<length)
 {

  x=alength;
  while(x>0)
  {
   x--;
   printf("%d",a[x]);
  }
  printf("\n");

  y=0;
  x=0;
  while(x<=alength)
  {
   a[x]+=a[x];
   a[x]+=y;
   if(a[x]>9){y=1;a[x]-=10;}else{y=0;}
   x++;
  }
  if(a[alength]>0){alength++;}

 }

 if(a!=NULL){free(a); a=NULL;}

 return 0;
}
```

## The Negative Powers of Two

The negative powers of two are what happens when you start at 1 and keep dividing by 2. Although normally fractional numbers of this sort can't exist for the integer type, I can simulate it using an array of decimal digits and my pattern recognition to write the small program below which gives the correct digits.

```
/*negative powers of two*/
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;

 char *a;
 int alength=2,x,y,temp;

 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}

 x=0;
 while(x<length)
 {
  a[x]=0;
  x++;
 }
 a[0]=1;

 while(alength<length)
 {
  printf("%i.",a[0]);

  x=1;
  while(x<alength)
  {
   printf("%d",a[x]);
   x++;
  }
  printf("\n");

  y=0;
  x=0;
  while(x<length)
  {
   if( (a[x]&1)==1 ){temp=5;}else{temp=0;} 
   a[x]>>=1;
   a[x]+=y;
   y=temp;
   x++;
  }
  if(a[alength]>0){alength++;}

 }

 if(a!=NULL){free(a); a=NULL;}

 return 0;
}
```




## Fibonacci Sequence

```
/*program to generate the fibonacci sequence*/
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;
 
 char *a,*b,*c;
 int alength,x,i;
 
 /*allocate memory for 3 arrays of equal size AKA length*/
 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}
 b=(char*)malloc(length*sizeof(*b));if(b==NULL){printf("Failed to create array b\n");return(1);}
 c=(char*)malloc(length*sizeof(*c));if(c==NULL){printf("Failed to create array c\n");return(1);}
 
 /*set all digits of these arrays to zero*/
 x=0;while(x<length){a[x]=0;b[x]=0;c[x]=0;x++;}
 a[0]=1; /*set lowest digit of a array to 1*/
 
 alength=1;
 while(alength<length)
 {
  i=0;
  x=0; while(x<alength)
  {
   c[x]=a[x]+b[x];
   c[x]+=i;
   i=c[x]/10;
   c[x]%=10;
   x++;
  }
  if(i>0){c[x]=i;alength++;}
  
  x=0;while(x<length){b[x]=a[x]; a[x]=c[x];   x++;}
  x=alength; while(x>0){x--;printf("%i",a[x]);} printf("\n");
 }
 
 if(a!=NULL){free(a); a=NULL;}
 if(b!=NULL){free(b); b=NULL;}
 if(c!=NULL){free(c); c=NULL;}
 
 return 0;
}
```

## Factorials

The factorials are what happens when you start at 1 and keep multiplying by the next number, for example, these are the first 6 factorials.

1
2
6
24
120
720

The number 720 is the factorial of 6 because 1x2x3x4x5x6==720. In fact, this number is what I based most of my Inkscape art on because I could divide many different numbers into 720. Factorials are highly composite which means they have many factors due to how they are generated.

```
/*program to generate the factorial sequence*/
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;
 
 char *a,*b,*c; /*pointers to arrays*/
 int alength,blength,clength; /*variable to keep track of the current length of the c array*/
 int x,ax,bx,cx,i; /* extra variables that are required for my personal multiplication system */
 
 /*allocate memory for 3 arrays of equal size AKA length*/
 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}
 b=(char*)malloc(length*sizeof(*b));if(b==NULL){printf("Failed to create array b\n");return(1);}
 c=(char*)malloc(length*sizeof(*c));if(c==NULL){printf("Failed to create array c\n");return(1);}

 /*set all digits of these arrays to zero*/
 x=0;while(x<length){a[x]=0;b[x]=0;c[x]=0;x++;}
 a[0]=1; /*set lowest digit of a array to 1*/
 b[0]=2; /*set lowest digit of b array to 2*/

 /*
  Keep track of the currently used length of each array.
  At the start, use only one digit
 */
 alength=1;
 blength=1;
 clength=1;
 
 while(clength!=length) /* main loop that repeats the process! */
 {
  /*stage 1: display the a array*/
  x=alength; while(x>0){x--;printf("%i",a[x]);} printf("\n");

  /*
   stage 2: multiply the a and b arrays together and store the result
   in the c array
  */
  bx=0;
  while(bx<blength)/*multiplication code begin*/
  {
   ax=0;
   while(ax<alength)
   {
    i=a[ax]*b[bx];
    cx=ax+bx; 
    while(cx<length && i>0)
    {
     c[cx]+=i;
     i=c[cx]/10;
     c[cx]%=10;
     cx++;
     if(cx>clength){clength=cx;}
    }
    ax++;
   }
   bx++;

  } /*multiplication code end*/



  /*stage 3: add 1 to the b array */
  i=1;
  bx=0;
  while(bx<length && i>0)
  {
   b[bx]+=i;
   i=b[bx]/10;
   b[bx]%=10;
   bx++;
  }
  if(bx>blength){blength=bx;}

  /* copy bytes of c[] to a[] then turn c to all zeroes again */
  /* then set alength to clength */
  x=0;while(x<length){a[x]=c[x];c[x]=0;x++;}alength=clength;
  
 }
 
 /*free all of the memory allocated for the three arrays*/
 if(a!=NULL){free(a); a=NULL;}
 if(b!=NULL){free(b); b=NULL;}
 if(c!=NULL){free(c); c=NULL;}
 
 return 0;
}
```