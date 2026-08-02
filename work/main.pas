program hexadecimal;

var //this is the global variable section
 a:integer;
 b:integer;
 
 radix:integer;       //current radix being used
 int_width:integer=1; //global integer width

(*
A function to print a string using Pascal's write function.
*)
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
 s:string=''; //string that will be built and returned from this function
 width:integer=0; //the current width
 c:integer;
 ch:char;
begin
 while (i>0) or (width<int_width) do
 begin

  c:=i mod radix; //get integer division modulus or remainder
  i:=i div radix; //get integer division quotient

  (*turn remainder c into character ch for digit in this radix*)
  if c<10 then
  begin
   ch:=chr(c+48);
  end
  else
  begin
   ch:=chr(c+55);
  end;

   s:=ch+s; //prefix the string with this character
   width+=1;

 end;

 intstr:=s; //return this string from the function

end;

(*use both putstr and intstr to print an integer*)
procedure putint(i:integer);
begin
 putstr(intstr(i));
end;

begin
 a:=0;
 b:=256;

 radix:=16; //set the radix used by intstr to 16

 while a<b do
 begin
  radix:=2;
  int_width:=8;
  putint(a);
  putstr(' ');
  radix:=16;
  int_width:=2;
  putint(a);
  putstr(' ');
  radix:=10;
  int_width:=3;
  putint(a);

  if (a>=0x20) and (a<=0x7E) then
  begin
   putstr(" ");
   putchar(a);
  end;

  putstr("\n");
  a+=1;
 end;
 
 putstr('Program completed!'#10);

end.

(*
 fpc main.pas && ./main
*)
