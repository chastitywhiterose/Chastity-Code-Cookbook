#!/bin/dash
x=0;
y=16;
while [ $x -lt $y ]
do
 echo $x;
 x=$((x+1))
done
