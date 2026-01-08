// g++ negativepower2.cpp && ./a
#include <iostream> 
using namespace std;
int main()
{
 int loops=40; //how many times the big loop will run
 int length=loops+1; //how many digits the array will use 
 int* a; //pointer for the array!
 try{a=new int[length];}
 catch(std::bad_alloc& ba) {cout << "Failed to allocate the memory for the array!\n"; return -1;}
 int x,y,z; //my favorite 3 variable names. Because I've played Minecraft too long!
 for(x=0;x<length;x++){a[x]=0;} a[0]=1;

 for(z=0;z<=loops;z++)
 { 
  cout << a[0] << ".";
  for(x=1;x<length;x++){cout << a[x];} cout << "\n";
  y=0; int y2=0;
  for(x=0;x<length;x++)
  {
   if((a[x]&1)==1){y2=5;}else {y2=0;} //if this digit is odd, 5 will be added to the next digit
   a[x]>>=1; //binary right shift to divide by 2;
   a[x]+=y;
   y=y2;
  }
 }

 delete[] a;
 return 0;
}

