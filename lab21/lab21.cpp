// C++ Main Program main.cpp

#include "string.h"
#include <iomanip>
#include <iostream>

using namespace std;

extern "C" int strLen(char *str);

int main() {

    string s1 = "Cat in the hat.";
    char s2[] = "Cat in the hat.";

    cout << s1 << " C++ length = " << s1.length() << endl;
    cout << s2 << " ARM length = " << strLen(s2) << endl;

    return 0;

}