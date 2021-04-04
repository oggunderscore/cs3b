#include "rasm5.h"

int elements;

int getElements() {
    return elements;
}

void incElements() {
    elements++;
}

void loadFile(int *data, int *cppArr, int *asmArr) {
    ifstream file;
    file.open("output.txt");

    string line;
    int loadedInt;

    clear();

    cout << "Loading file...";

    elements = 0;

    //tData = (int*) calloc (200000, sizeof(int)); // calloc size of int of size 200000

    for (int x = 0; x < 200000; x++) {

        if (file.is_open()) {
            getline(file, line);
            loadedInt = stoi(line); // Convert string to int
            data[x] = loadedInt; // Load it into data
            incElements();
        }
    }

    for (int x = 0; x < 200000; x++) {
        cppArr[x] = data[x];
    }

    for (int x = 0; x < 200000; x++) {
        asmArr[x] = data[x];
    }

    file.close();

    cout << "Done." << endl;
    pause();
}