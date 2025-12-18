/*
 This NAND function does a bitwise AND and inverts it. However, it also does another AND by 0xF to ensure that only the lower 4 bits remain.
 The idea is that only 4 bits are required to show all combinations of any bitwise operation. For this reason the extra bits are excluded.
 While NAND is a compound operation in C. Supposedly, according to the game Turing Complete, the NAND is a basic gate which can be used to build all the other logic gates.
 This function, and indeed this entire header file, is meant to prove this theory.
*/

int nand(int a,int b)
{
 return ~(a&b)&0xF;
}

/*
 the NOT function is achieved by passing one number as both arguments of the NAND function
 */

int not(int a)
{
 return nand(a,a);
}

int and(int a,int b)
{
 return not(nand(a,b));
}

int or(int a,int b)
{
 return nand(not(a),not(b));
}

int nor(int a,int b)
{
 return not(nand(not(a),not(b)));
}

int xor(int a,int b)
{
 return and( nand(a,b) , nand(not(a),not(b) ) );
}

int xnor(int a,int b)
{
 return nand( nand(a,b) , nand(not(a),not(b) ) );
}

void turing_bitwise_nand(int a,int b)
{
 int c;

 radix=2;
 int_width=4;

 printf("%s A\n",intstr(a));
 printf("%s B\n\n",intstr(b));
  
 c=not(nand(a,b));
 printf("%s AND\n",intstr(c));
 c=nand(not(a),not(b));
 printf("%s OR\n",intstr(c));
 c=and( nand(a,b) , nand(not(a),not(b) ) );
 printf("%s XOR\n\n",intstr(c));
 
 c=nand(a,b);
 printf("%s NAND\n",intstr(c));
 c=not(nand(not(a),not(b)));
 printf("%s NOR\n",intstr(c));
 c=nand( nand(a,b) , nand(not(a),not(b) ) );
 printf("%s XNOR\n\n",intstr(c));
}
