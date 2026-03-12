#include <iostream>
#include <cstdio>
#include "Helper.h"
#include <climits>

int main()
{
    int x;
    char input[0x100]; //an array to store user input
    std::cout << "This program tests the required functions:\n\n";

    std::cout << "IsInteger (tested with user input loop)\n";

    std::cout << "Enter a number (in decimal) and I can tell you about it.\n";

    bool loop_input = true;
    while (loop_input)
    {
        std::cin >> input;
        std::cin.clear();
        std::cin.ignore(INT_MAX, '\n');

        if (Helper::IsInteger(input))
        {
            std::cout << "Yes! That is a good integer!\n";
            x = Helper::strint(input);
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

    std::cout << "\nBubbleSort\n";

    //declare an array of numbers in the wrong order
    int a[] = { 61, 11, 13, 17, 19, 31, 37, 2 ,3 ,5 ,7 ,41 ,43 ,47 ,23,29,53 ,59 };
    int size = sizeof(a) / 4; //obtain the size of this array

    std::cout << "\nScrambled Array:\n";
    x = 0;
    while (x < size)
    {
        std::cout << a[x] << " ";
        x++;
    }
    std::cout << "\n";

    Helper::BubbleSort(a, size);

    std::cout << "\nSorted Array:\n";
    x = 0;
    while (x < size)
    {
        std::cout << a[x] << " ";
        x++;
    }
    std::cout << "\n";
}
