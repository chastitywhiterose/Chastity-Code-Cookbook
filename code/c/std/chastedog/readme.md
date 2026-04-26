# chastedog

The chastedog utility gets its name from the cat utility which is on all Linux distributions. This program is more advanced that cat because it can selectively quote part of a file based on the arguments.

For example, to quote the "putstring" function inside the "chastelib.h" header file, you would use this command

./main chastelib.h "int putstring" "}"

This works because "int putstring" is the beginning of the definition of the function. The "}" works because I have programmed it to specifically search for the valid end of a block in the C programming language when this is used as an end string. Otherwise, it might stop too soon.