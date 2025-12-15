/*

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
 printf("%s NXOR\n",intstr(c));

/*
 c=a^0xF;
 printf("%s NOT A\n",intstr(c));
 c=b^0xF;
 printf("%s NOT B\n\n",intstr(c));
 */

}
