#!/bin/bash
a=0;
b=10;
while test $a -ne $b
do
 echo "$a";
 a=`expr $a + 1`;
done

