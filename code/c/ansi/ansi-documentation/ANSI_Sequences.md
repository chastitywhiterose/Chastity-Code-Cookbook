# ANSI Escape Code Sequences

ANSI escape codes allow moving the cursor and changing the color of text in a Linux terminal. The best part is that these sequences can be constructed by sending the correct byte sequence of characters no matter what programming language you are using. Technically, this means that even a library like ncurses can be constructed from knowing about them.

<https://notes.burke.libbey.me/ansi-escape-codes/>  
<https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797>  

My goals are very simple. I want to create a small text program involving cursor movement and some colors. Perhaps a hex editor or text editor will be good projects.

However, if I have the time and skill, I would like to make a text mode game that is fun to play and is an original idea.

# Correct Input

In order to make an interactive program in a terminal, it is essentialy to disable line buffering so that each key can trigger an action without waiting until an entire line of text has been entered. By my research, I discovered that the magic command to do this on a Linux system is this:

`stty cbreak`

Therefore, if this is run either before the program, or during it such as C's system function:

`system("stty cbreak");`

Then it is possible to make a game using only the C standard library on a Linux system. You have to handle the keys pressed by using getchar or a similar function to read from stdin, but it can be done!
