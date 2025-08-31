 #!/bin/bash
 declare -i x y length;
 length=1000
 declare -ai c #declare array of integers

 x=0;
 while [ $x -lt $length ]
 do
  c[x]=0;
  x=x+1;
 done
 c[0]=1;

 echo 2;

 x=3;
 while [ $x -lt $length ]
 do
  echo $x;
  y=x;
  while [ $y -lt $length ]
  do
   c[y]=1;
   y=y+x;
  done
  while [ $x -lt $length ] &&  [ ${c[$x]} -gt 0 ]
  do
   x=x+2
  done
 done
 
 