program hexadecimal;

var
 s:string;
 x:integer;
 y:integer;
 radix:integer;
 
procedure putstr(s:string);
begin
write(s);
end;

(*
 a function to return a string form of an integer
 using the global radix variable
*)
function intstr(i:integer):string;
var
 s:string;
 c:integer;
 ch:char;
begin
  // start of hex section
  s:=''; //start with empty string
  
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

intstr:=s;

end;


begin
 x:=0;
 y:=256;

 radix:=16;

s:='dudeman';

 while x<y do
 begin
 write('decimal ',x);

 putstr('I am gay');

  //write(' hexadecimal ',intstr(x));
  
  putstr(intstr(x));

  writeln();
  x:=x+1;
 end;

end.



(*
 fpc main.pas && ./main
*)
