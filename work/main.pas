program pow2;

var
 a,b,x,y:integer;
 c:array[0..255] of integer;
 length:integer=20; //minimum length for digits

begin;
 a:=0;
 b:=64; //highest exponent we want

 x:=0;
 while x<length  do
 begin
  c[x]:=0; //set digits to 0
  x:=x+1;
 end;
 c[0]:=1; //but set lowest to 1

 //main loop
 while a<=b do
 begin;

 //display all digits
 x:=length;
 while x>0 do
 begin
  x:=x-1;
  write(c[x]);
 end;
 //write power notation and a newline
 writeln(' 2^',a); 

 y:=0;
 x:=0;
 while x<=length do
 begin
  c[x]:=c[x]+c[x];
  c[x]:=c[x]+y;
  if c[x]>9 then begin y:=1; c[x]:=c[x]-10; end
  else begin y:=0; end;
   x:=x+1;
  end;
  if c[length]>0 then begin length:=length+1; end;

  a:=a+1;
 end;

end.
