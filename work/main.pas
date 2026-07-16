program pow2;

var
 a:integer;
 b:integer;
 x:integer;
 y:integer;
 c:array[0..255] of integer;
 length:integer=20;

begin
 a:=0;
 b:=16;

 //set digits to 0
 x:=0;
 while x<length  do
 begin
  c[x]:=0;
  x:=x+1;
 end;
 c[0]:=1; //but set lowest to 1

 while a<=b do
 begin

 //display all digits
 x:=length;
 while x>0 do
 begin
  x:=x-1;
  write(c[x]);
 end;
 writeln(' 2^',a); //write power notation and a newline

 a:=a+1;
 end;

end.


{*
 x:=1;
 while x<>0 do
 begin
  WriteLn(x);
  x:=x+x;
 end;
*}
