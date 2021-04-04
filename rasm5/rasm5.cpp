#include "rasm5.h"

int data[200000], cppArr[200000], asmArr[200000];

int main() {

    generate();

    printMenu(data, cppArr, asmArr);
    
    return 0;
}