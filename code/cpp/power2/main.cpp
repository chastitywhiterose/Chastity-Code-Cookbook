// g++ power2.cpp && ./a
#include <iostream> 
using namespace std;
int main()
{
 int length=32; //how many digits the array will use
 int* a; //pointer for the array!
 try{a=new int[length];}
 catch(std::bad_alloc& ba) {cout << "Failed to allocate the memory for the array!\n"; return -1;}
 int x,y,z; //my favorite 3 variable names. Because I've played Minecraft too long!

 for(x=0;x<length;x++){a[x]=0;} a[0]=1;

 for(z=0;z<=32;z++)
 { 
  for(x=length-1;x>=0;x--){cout << a[x];} cout << "\n"; //output
  y=0;
  for(x=0;x<length;x++)
  {
   a[x]<<=1; //binary left shift to multiply by 2;
   a[x]+=y;  //add the carry
   if(a[x]>9){y=1;a[x]-=10;}else{y=0;}
  }
 }

 delete[] a;
 return 0;
}

