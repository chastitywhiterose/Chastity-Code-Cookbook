#!/bin/bash
echo "The name of this script is $0" # print arg 0, the name of the script
echo "This script reminds me how to use command line arguments in Bash"
echo "There are $# arguments"

if [ $# -ne 0 ] # if the number of arguments is not equal to zero
then
 echo $@ # print all arguments, excluding the name of the script
 echo $* # print all arguments, except that they are combined into one string
 echo The first argument is $1 # print arg 1, but only if it exists
fi
