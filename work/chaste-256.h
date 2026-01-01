/*
  Chaste-256

I am not sure how far I will go with this, but I have in mind to create my own Instruction Set Architecture. It will be smaller and simpler than anything else that exists. In fact it has to be because I am not smart enough to emulate the existing x86 machines nor the RISC machines even though they are probably easier.

Currently, this file is my experimentation ground for the instructions I will create. Each instruction will have a descriptive name and will be implemented by a function.
*/

char registers[2];

#define A &registers[0]
#define B &registers[1]

char RAM[0x100];
 
void Load_Register_Integer(char *r,char i)
{
 *r=i;
}

void print_RAM()
{
 int x,y;
 int width=16,height=16;
 
 radix=16;
 int_width=2;
 
 y=0;
 while(y<height)
 {
  x=0;
  while(x<width)
  {
   putint(RAM[x+y*width]);
   putstring(" ");
   x++;
  }
  putstring("\n");
  y++;
 }

}
