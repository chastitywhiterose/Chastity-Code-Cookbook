#include <iostream>
using namespace std;
//#include "chastelib.hpp"

/*
 This is probably a silly example of a class in C++, but since an integer is what I am most comfortable with
 I will make an integer class which contains only a single int which is really just the short name for an integer
*/

class integer
{
 public:

 int i;

 integer()
 {
  cout << "integer set to default zero value\n";
  i=0;
 }

 void set(int a)
 {
  i=a;
 }
 
 void print()
 {
  cout << i;
 }

 void println()
 {
  cout << i << '\n';
 }


};

int main(int argc, char *argv[])
{
 integer a;
 a.set(6);

 a.println();

 return 0;
}
