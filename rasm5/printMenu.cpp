#include "rasm5.h"

void printMenu(int *data, int *cppArr, int *asmArr) {

    char choice;
    bool exit = false;  

    do {

       clear();

        cout << "\t\t  Rasm 5 C vs Assembly\n\t\tFile Element Count: " << getElements()
        << endl << "----------------------------------------------------\n" << "C        Bubblesort Time: "
        << getCppTime() << " secs\nAssembly Bubblesort Time: " << getAsmTime() 
        << " secs\n----------------------------------------------------\n" << "<1> Load input file (integers)"
        << "\n<2> Sort using C Bubblesort algorithm\n<3> Sort using Assembly Bubblesort algorithm\n<4> Quit" << endl;

        cin >> choice;

        switch(choice) {
            case '1':
                loadFile(data, cppArr, asmArr);
                break;
            case '2':
                cppSort(data, cppArr);
                break;
            case '3':
                asmSort(data, asmArr);
                break;
            case '4':
                exit = true;
                saveFile(data, cppArr, asmArr);
                clear();
                break;
            case '5':
                cout << "DATA" << endl;
                for (int x = 0; x < 100; x++) {
                    cout << data[x] << endl;
                }
                cout << "cppArr" << endl;
                for (int x = 0; x < 100; x++) {
                    cout << cppArr[x] << endl;
                }
                cout << "asmArr" << endl;
                for (int x = 0; x < 100; x++) {
                    cout << asmArr[x] << endl;
                }
                break;
            case '6':
                cout << "Sorting both..." << endl;
                cppSort(data, cppArr);
                asmSort(data, asmArr);
                break;
        }

    } while (!exit);

}