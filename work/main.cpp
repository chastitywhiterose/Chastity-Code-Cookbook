#include <iostream>
using namespace std;
//#include "chastelib.hpp"

/*
 This is probably a silly example of a class in C++, but since an integer is what I am most comfortable with
 I will make an integer class which contains only a single int which is really just the short name for an integer
 The current value of the integer is public and can always be accessed as objectname.i
 This class has functions to set the value of the integer by the set method and other methods to do arithmetic
*/



class integer
{
 static int id; //the number that idenfifies the order in which this object was created*/

 public:

 int i;

 integer()
 {
  cout << "integer id " << id << " set to default zero value\n";
  i=0;
  id++;
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

 void add(int a) { i+=a; }

 void sub(int a) { i-=a; }

 void mul(int a) { i*=a; }

 void div(int a) { i/=a; }

 void mod(int a) { i%=a; }


};

int integer::id=0; //this is where the starting value for the static integer is declared

int main(int argc, char *argv[])
{
 integer a,b;

 a.set(1);
 b.set(256);

 while(a.i<b.i && a.i>0)
 {
  a.println();
  a.mul(2);
 }

 return 0;
}
