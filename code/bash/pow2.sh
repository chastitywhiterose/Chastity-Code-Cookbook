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
