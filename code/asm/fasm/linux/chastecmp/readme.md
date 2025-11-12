# chastecmp

chastecmp: compares two files in hexadecimal
	chastecmp file1 file2

Files must be same size for best results. As soon as the end of either files is reached, the program ends. This is based on the assumption that it is used on files of a fixed format or size.

Example files: video game save files, executables compiled with minor changes in variables, text files with typos in one version and not another.

## Purpose

This program is designed to be a complement to my previous program: chastehex.

<https://gitlab.com/chastitywhiterose/chastehex>

<https://github.com/chastitywhiterose/chastehex>

The two programs help each other in two ways.

First, if you have two files that are mostly similar, you can use chastecmp to find which bytes are different.

Second, if you were to make a copy of a file and then use chastehex to modify the bytes of the file, then chastecmp could tell you which bytes you had modified when compared to the original file.
