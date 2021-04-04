#include "rasm5.h"

double asmBubbleTime;

double getAsmTime() {
    return asmBubbleTime;
}

void asmSort(int *data, int *asmArr) {

    clear();

    cout << "Starting ARM Assembly Bubble sort..." << endl;

    clock_t clock1 = clock();

    asmBubbleSort(asmArr, 200000);

    clock_t clock2 = clock();
    asmBubbleTime = int(clock2 - clock1) / int(CLOCKS_PER_SEC / 1000); 
    asmBubbleTime = asmBubbleTime / 1000;

    cout << "Done." << endl;

}