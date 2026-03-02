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
 string s="100"; //create C++ string for input integer
 //pass s to force the usage of the overloaded strint function
 b=strint(s);
 while(a<b)
 {
  cout << intstr(a,2,8) << " ";
  cout << intstr(a,16,2) << " ";
  cout << intstr(a,10,3);
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

