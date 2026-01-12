#include <iostream>
#include <string>

int radix = 10;

/*
 The following function was written for accurate conversion to replace the stoi from the C++ standard library.
 It will return 0 if the string does not at least start with a valid string representation of an integer.
 Therefore, at least it never crashes. Most importantly, it also prints which characters were invalid if the wrong string is entered.
*/

int strint(std::string s)
{
    int i = 0, x = 0;
    char c;
    if (radix < 2 || radix>36) { printf("Error: radix %i is out of range!\n", radix); return i; }
    while (s[x] == ' ' || s[x] == '\n' || s[x] == '\t') { x++; }
    while (s[x] != 0)
    {
        c = s[x];
        if (c >= '0' && c <= '9') { c -= '0'; }
        else if (c >= 'A' && c <= 'Z') { c -= 'A'; c += 10; }
        else if (c >= 'a' && c <= 'z') { c -= 'a'; c += 10; }
        else if (c == ' ' || c == '\n' || c == '\t') { return i; }
        else { std::cout << "Error: " << s[x] << " is not an alphanumeric character!" << std::endl; return i; }
        if (c >= radix) { std::cout << "Error: " << s[x] << " is not a valid character for radix " << radix << std::endl; return i; }
        i *= radix;
        i += c;
        x++;
    }
    return i;
}

int main()
{
    std::string s;
    int i = 0;
    while (i < 1 || i>10)
    {
     std::cout << "Please enter a number (1-10): ";
     std::getline(std::cin, s);
     i = strint(s);
     std::cout << i << std::endl;
    }
    std::cout << "You entered: " << i << "(finally)" << std::endl;
}
