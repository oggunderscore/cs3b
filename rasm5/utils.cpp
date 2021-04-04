#include "rasm5.h"

void clear() {
    system("clear");
}
void pause() {
    system("pause");
}

void BubbleSort (int *a, int length) {
    int i, j, temp;

    for (i = 0; i < length; i++) {
        for (j = 0; j < length - i - 1; j++) {
            if (a[j + 1] < a[j]) {
                temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;
            }
        }
    }
}

void saveFile(int *data, int *cppArr, int *asmArr) {

    // TODO: Save to c_output.txt

    cout << "\nSaving to c_output.txt..." << endl;

    ofstream cfile;
    cfile.open("c_output.txt");

    for (int x = 0; x < 200000; x++) {
        cfile << cppArr[x] << endl;
    }

    cfile.close();

    // TODO: Save to a_output.txt

    cout << "\nSaving to a_output.txt..." << endl;
    ofstream afile;
    afile.open("a_output.txt");

    for (int x = 0; x < 200000; x++) {
        afile << asmArr[x] << endl;
    }

    afile.close();
}