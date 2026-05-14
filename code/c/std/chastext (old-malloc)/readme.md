# chastext readme

chastext is a search and replace program for text files. It is very basic but also extremely fast. It does not support regular expressions or anything fancy but it can be used to find all occurrences of a string in a file. For example, suppose you wrote a book with a character's name but later wanted to change it. Instead of manually finding them all or loading up a text editor with a search and replace feature, you can use this program instead.

It can also edit binary files to a limited extent, although it will only work if the search and replacement strings are of equal length and do not change the size of the files. Text files do not suffer from this limitation because the size can change and they still work.

For example, consider changing the following C Hello World program.

```
#include <stdio.h>
int main()
{
 printf("Hello, World!\n");
 return 0;
}
```

We can change the string that will be printed with one command.

```
chastext main.c "Hello" "Goodbye"
```

And then we will get the following:

```
#include <stdio.h>
int main()
{
 printf("Goodbye, World!\n");
 return 0;
}
```

chastext never writes to files and only reads from them. The idea is that you will redirect the output of your changes to another file or just display them on stdout without making any permanent changes until you are ready.

It can only replace one string at a time and therefore you need to write a script if you have several changes that you want to make. However, you can use this opportunity to save them as separate files so that you keep track of them and always keep the original file the same.

However, this program is extremely useful for changing configuration files from a script rather than having to open up a regular text editor and manual enter new values.
