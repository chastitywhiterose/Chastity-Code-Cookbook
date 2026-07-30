program hexadecimal;

var
 s:string;
 x:integer;
 y:integer;
 i:integer;
 c:integer;
 ch:char;
 radix:integer;

begin
 x:=0;
 y:=256;

 radix:=16;

 while x<y do
 begin
 write('decimal ',x);

  // start of hex section
  s:=''; //start with empty string
  i:=x;  //set i to x

  while i>0 do
  begin

   c:=i mod radix; //get integer division modulus or remainder
   i:=i div radix; //get integer division quotient

   if c<10 then
   begin
    ch:=chr(c+48);
   end
   else
   begin
    ch:=chr(c+55);
   end;

   s:=ch+s; //prefix the string with this character

  end;

  write(' hexadecimal ',s);

  writeln();
  x:=x+1;
 end;

end.

(*
 fpc main.pas && ./main
*)
