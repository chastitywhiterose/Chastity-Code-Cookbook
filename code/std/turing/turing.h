/*
This source file and the program based on it is meant to help me visualize the output of bitwise operations for the Steam game "Turing Complete". I am very familiar with bitwise operations but seeing them visually and verifying them with a valid program will help me figure out how some gates are used to make other gates.
*/

void turing_bitwise(int a,int b)
{
 int c;

 radix=2;
 int_width=4;

 putstring("Test of Bitwise Operations\n\n");
 
 printf("%s A\n",intstr(a));
 printf("%s B\n\n",intstr(b));
 

 
 c=a&b;
 printf("%s AND\n",intstr(c));
 c=a|b;
 printf("%s OR\n",intstr(c));
 c=a^b;
 printf("%s XOR\n\n",intstr(c));
 
 c=(a&b)^0xF;
 printf("%s NAND\n",intstr(c));
 c=(a|b)^0xF;
 printf("%s NOR\n",intstr(c));
 c=(a^b)^0xF;
 printf("%s NXOR\n\n",intstr(c));

}
