#include <iostream>
#include <string>
using namespace std;
#include "chastelib_cout.hpp"
#include "chastelib_string.hpp"

int main(int argc, char *argv[])
{
 int a=0,b;

 radix=16;
 int_width=1;

 putstring("Official test suite for the C++ version of chastelib.\n");

 string s="20"; //create C++ string for input integer
 //pass s force the usage of the overloaded strint function from chastelib_string.hpp
 b=strint(s);
 while(a<b)
 {
  radix=2;
  int_width=8;
  cout << intstr(a,2,8);
  putstring(" ");
  radix=16;
  int_width=2;
  putint(a);
  putstring(" ");
  radix=10;
  int_width=3;
  putint(a);

  if(a>=0x20 && a<=0x7E)
  {
   putstring(" ");
   cout.put(a);
  }

  putstring("\n");
  a+=1;
 }
  
 return 0;
}

