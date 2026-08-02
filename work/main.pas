program hexadecimal;

const
 string0='Official test suite for the Pascal version of chastelib.'#10;

var //this is the global variable section
 a:integer;
 b:integer;
 
 radix:integer;       //current radix being used
 int_width:integer=1; //global integer width
 strint_errors:integer=0; //error result for strint function

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

function strint(s:string):integer;
var
 i:integer=0; //integer that will be built and returned from this function
 x:integer=1; //index used to scan forward through the string
 c:integer;
begin
 strint_errors := 0; (*set zero errors before we parse the string*)
 if( radix<2 or radix>36 ) then
 begin
  strint_errors++;
  writeln('Error: radix ',radix,' is out of range!');
 end
 while(x<=length(s))
 begin
  c=*s;
  if( c >= '0' && c <= '9' ){c-='0';}
  else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' || c == '\n' || c == '\t' ){break;}
  else{ strint_errors++; printf("Error: %c is not an alphanumeric character!\n",*s);break;}
  if(c>=radix){ strint_errors++; printf("Error: %c is not a valid character for radix %i\n",*s,radix);break;}
  i*=radix;
  i+=c;
  s++;
 end;
 return i;
end;














































begin
 a:=0;
 b:=256;

 radix:=16; //set the radix used by intstr to 16

 putstr(string0);

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

  if (a>=$20) and (a<=$7E) then
  begin
   putstr(' ');
   putstr(chr(a));
  end;

  putstr(#10);
  a+=1;
 end;
 
 putstr(string0);

end.

(*
 fpc main.pas && ./main
*)
