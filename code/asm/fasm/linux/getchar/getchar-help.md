This small program reads character in Linux by calling the read call with the right arguments to read one byte from standard input.

Using one of the following commands will disable line buffered input. This mean it will not be required to press enter before something happens in the program.

stty cbreak
stty -icanon