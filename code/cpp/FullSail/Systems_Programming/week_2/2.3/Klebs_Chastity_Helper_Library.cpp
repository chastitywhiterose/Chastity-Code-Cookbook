#include <iostream>
#include "Helper.h"

int main()
{
    int x;
    char input[0x100]; //an array to store user input
    std::cout << "Required Functions:\n";

    std::cout << "Enter a number (in decimal) and I can tell you about it.\n";

    bool loop_input = true;
    while(loop_input)
    {
        std::cin >> input;
        std::cin.clear();
        std::cin.ignore(INT_MAX, '\n');
        
        if (Helper::IsInteger(input))
        {
            std::cout << "Yes! That is a good integer!\n";
            x=Helper::strint(input);
            loop_input = false;
        }
        else
        {
            std::cout << "No! That is not an integer! Please try again!\n";
        }

    }

    std::cout << "x==" << x << "\n";

    std::cout << "PrintIntegerBinary\n";
    Helper::PrintIntegerBinary(&x);
    std::cout << "\n";

    std::cout << "PrintIntegerHex\n";
    Helper::PrintIntegerHex(&x);
    std::cout << "\n";

    std::cout << "PrintIntegerOct\n";
    Helper::PrintIntegerOct(&x);
    std::cout << "\n";

    
    std::cout << "\n";
}

