#include "rasm5.h"

using namespace std;

void generate() {
    cout << "\nGenerating file..." << endl;

    int randomNumber;

    srand((unsigned) time(0));

    ofstream file;
    file.open("output.txt");

    for (int x = 0; x < 200000; x++) {

        randomNumber = (rand() % 1000000); // Assign random number of 1mil

        file << randomNumber << endl; // Possibly replace with \n to have better formatting?

    }

    file.close();

    cout << "Done.\n\n" << endl;
}