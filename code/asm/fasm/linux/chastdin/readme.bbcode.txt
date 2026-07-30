[b]chastdin readme[/b]

This is the full documentation for the program known as "chastdin". This name stands for "Chastity's STandDard INput". The program serves two purposes.

The first purpose of this program was to test Chastity's library of functions for reading keyboard input and comparing the strings entered with predefined strings to control program execution.

The second purpose was putting all the functions together to form a complete program that not only tests the standard input library, but also does something useful. When you first run the program, it will display a message like the following

[code]
chastdin is a stack based interactive calculator
that reads stdin for numbers and commands.
Numbers are pushed on the stack for all math.
Each line can contain multiple numbers or commands.

Arithmetic commands are add,sub,mul,div,rem
The exit command ends the program
The ? command prints the entire stack
The setradix command changes the radix for input and output
[/code]

This is an accurate, but incomplete documentation of what the program does. Therefore, I have described each command below and how to use it. Some may be obvious while others deserve a longer explanation.

[b]add[/b]

The "add" command is a 3 letter word that does exactly when you would expect. Here is an example of how you could use it.

[code]
1987 40 add ?
[/code]

This line will add the numbers 1987 and 40 to the stack, then it will add them and then use the ? command to display what is on the stack. The result in this case will be 2027 because that is the year that Chastity becomes the 40 year old virgin because she was born in 1987 on May 15th.

[b]sub[/b]

The "sub" command is a 3 letter word abbreviation for "subtract". For example, the following commands will push 100 and 36 to the stack and subtract to get 64.

[code]
100 36 sub ?
[/code]

One thing to notice is that there are no negative numbers in the chastdin program. So if you already have the number 64 on the stack from the previous commands and then tried to subtract 65:

[code]
65 sub ?
[/code]

You will get an absurdly high number of 4294967295 if the data type of the implementation is a 32 bit unsigned integer. The specific data type can be changed in the C source code but the 32-bit Linux Assembly version is always this type because of the size of the Intel registers used.

[b]mul[/b]

The "mul" command is a 3 letter word abbreviation for "multiply". For example, the following commands will push 5 and 15 to the stack and multiply to get 75.

[code]
5 15 mul ?
[/code]

While multiplication is pretty straightforward, division uses two different commands described below.

[b]div[/b]

The "div" command is a 3 letter word abbreviation for "divide". For example, the following commands will push 60 and 7 to the stack and multiply to get the quotient.

[code]
60 7 div ?
[/code]

The quotient will be 8 because 7 can divide into 60 a maximum of 8 times. However, this is 56 and is not completely equal to 60. There is a separate command to get the remainder of division.

[b]rem[/b]

The "rem" command is a 3 letter word abbreviation for "remainder" of division. In some programming languages, the remainder is call the modulus. The following command can be used to get the remainder of division instead of the quotient.

[code]
60 7 rem ?
[/code]

This will be 4 because the original number was 60 and the quotient is 56. The difference between these two numbers will always be 4.

Technically, you can also get the remainder doing something like this:

[code]
60 7 60 7 div mul sub ?
[/code]

This works because the arithmetic always uses what is currently on the stack. By pushing 60 and 7 twice, we first divide for the quotent which is 8, then multiply that 8 by the 7 on the stack to get 56 which is then subtracted from the 60.

But don't worry, you don't need to do such madness because I put the rem command into the program already. But if you do understand why the longer version works, then you understand the full magic of why a postfix notation calculator works so well.

[b]setradix[/b]

The setradix command can change the radix or base that is being used for numbers. For example, the number 999 in decimal can be converted to hexadecimal.

[code]
999 16 setradix ?
[/code]

It works because 999 pushed to the stack in the default decimal radix, but then 16 is pushed and then used to set the new radix to base 16 also called hexadecimal.

If you know about the binary and hexadecimal number bases, you will understand how important a conversion tool is when you are programming or just trying to hex edit a save file of your favorite retro video games.

[b]exit[/b]

Whenever you are done using the chastdin program, you can use the "exit" command. For example, the following will exit the program and then print "Hello World!" because once the program ends, the operating system will return control to the shell and then run literally any command on your system. Use this power wisely!

[code]
exit echo "Hello World!"
[/code]

That is all you need to know about using the chastdin program. Understanding how it actually works requires understanding the source code Chastity wrote.

However, because the program only reads standard input and then writes to standard output, it can be written in every programming language that exists without requiring external libraries.
