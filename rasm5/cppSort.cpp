#include "rasm5.h"

double cppBubbleTime;

double getCppTime() {
    return cppBubbleTime;
}

void cppSort(int *data, int *cppArr) {
    clear();

    cout << "Starting C++ Bubble sort..." << endl;

    clock_t clock1 = clock();

    BubbleSort(cppArr, 200000);

    clock_t clock2 = clock();
    cppBubbleTime = int(clock2 - clock1) / int(CLOCKS_PER_SEC / 1000); 
    cppBubbleTime = cppBubbleTime / 1000;

    cout << "Done." << endl;

}