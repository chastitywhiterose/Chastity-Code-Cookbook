/*
 C++ string extension to the chastelib library

 An extension library for chastelib that uses std::string that exists in C++
 There are only two functions in this library but they are powerful if you know how to use them
 These were designed with the idea that they will be useful in C++ programs
 where strings are objects of a class rather than a pointer to
 an array of characters.
*/

/*
 This version of intstr has the same name as the libc version.
 For the compiler to know which of the two functions is being called,
 I had to give it a different number of arguments. 
 My solution was to pass the desired radix and integer width as arguments!
 This means that I can generate perfect strings from any integer
 and send them to cout for perfectly formatted integers in my style!
 Because C++ allows strings to be returned from a function
 and since all data is passed as arguments. No global variables are needed.
 Th intstr function can be called in any context at any time!
*/

string intstr(unsigned int i,int radix,int int_width)
{
 int width=0;
 string s; //create new empty string
 char c; //character used to store value of digit each loop
 while(i!=0 || width<int_width)
 {
  c=i%radix;
  i/=radix;
  if(c<10){c+='0';}
  else{c=c+'A'-10;}
  s=c+s;
  width++;
 }
 return s;
}


/*
 This function is an overloaded function for C++ style strings.
 Just like the other strint function it converts an string to an integer
 But it works with the std::string class, it allows compatibility with modern C++ programs that use this type.
 The characters of the string class can be indexed with [] just like C strings
 The compiler is smart enough to know when this function is being called
 because a string object is not the same as a char pointer
*/

int strint(string s)
{
 int i=0,x=0;
 char c;
 if(radix<2 || radix>36) { cout << "Error: radix " << radix << "is out of range!\n"; }
 while(s[x] == ' ' || s[x] == '\n' || s[x] == '\t') { x++; }
 while(s[x] != 0)
 {
  c = s[x];
  if (c >= '0' && c <= '9') { c -= '0'; }
  else if(c >= 'A' && c <= 'Z') { c -= 'A'; c += 10; }
  else if(c >= 'a' && c <= 'z') { c -= 'a'; c += 10; }
  else if(c == ' ' || c == '\n' || c == '\t') { break; }
  else{ cout << "Error: " << c << " is not an alphanumeric character!" << endl; break; }
  if(c >= radix){ cout << "Error: " << s[x] << " is not a valid character for radix " << radix << endl; break; }
  i *= radix;
  i += c;
  x++;
 }
 return i;
}

