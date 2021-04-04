#ifndef rasm5_h
#define rasm5_h

#include <iostream>
#include <ctime>
#include <cstdlib> // Malloc
#include <fstream>
#include <string>
#include <time.h>
#include <stdio.h>
#include <math.h>

using namespace std;

void clear();
void pause();
void printMenu(int *, int *, int *);
void loadFile(int *, int *, int *);
void cppSort(int *, int *);
void asmSort(int *, int *);
void BubbleSort(int [], int);
extern "C" void asmBubbleSort(int *, int);
int getElements();
double getCppTime();
double getAsmTime();
void incElements();
void generate();
void saveFile(int *, int *, int *);

#endif