#include <iostream>
using namespace std;
//#include "chastelib.hpp"

class integer
{
 public:

 int i;

 integer()
 {
  cout << "integer set to default zero value\n";
 }
 
 void operator=(int a)
 {
  i=a;
 }

 void operator+=(int a)
 {
  i+=a;
 }


};

int main(int argc, char *argv[])
{
 integer a;
 a=6;

 a+=7;

 a=a+1;

// a+=7;
 cout << a.i << "\n";
 return 0;
}
