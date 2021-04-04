	.data
title:                  .asciz      "\t\tRASM 4 TEXT EDITOR\n\tData Structure Heap Memory Consumption: "
bytes:                  .asciz      " bytes"                    @ For menu counter reference
nodes:                  .asciz      "\n\tNumber of Nodes: "
mainMenuText:           .asciz      "\n<1> View all strings\n\n<2> Add string\n\t<a> from Keyboard\n\t<b> from File. Static file named input.txt\n\n<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).\n\n<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n\n<5> String search. Regardless of case, return all strings that match the substring given.\n\n<6> Save File (output.txt)\n\n<7> Quit\n\n"

numNodes:               .word       0                           @ Stores number of nodes program has
numBytes:               .word       0                           @ Stores number of bytes consumed within program

    .text
    .global         numNodes
    .global         numBytes
    .global         mainMenu

updateNodes:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    cpy     r0,     r10                         @ Get LL
    bl      LinkedList_len                      @ Get Length of LL

    ldr     r1,     =numNodes                   @ Load numNodes
    str     r0,     [r1]                        @ Store into numNodes

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call


@ Print main menu
mainMenu:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register


    mainMenuLoop:

        @ Update NumNodes
        bl      updateNodes
        bl updateBytes

        bl      clearScreen                         @ Clean Screen

        ldr     r0,     =title                      @ Load title
        bl      putstring                           @ Print title
        ldr     r0,     =numBytes                   @ Load number of bytes int
        bl      printNum                            @ Print number
        ldr     r0,     =bytes                      @ Load string bytes
        bl      putstring                           @ Print it
        ldr     r0,     =nodes                      @ Load numOfNodes text
        bl      putstring                           @ Print
        ldr     r0,     =numNodes                   @ Load actual numNodes
        bl      printNum                            @ printnum
        ldr     r0,     =mainMenuText               @ Load the rest of text
        bl      putstring                           @ Print entire

        ldr     r0,     =inputText                  @ Load input text
        bl      putstring                           @ Print

        bl      getCharInput                        @ Get input from user

        @ Check if == 1
        cmp     r0,     #0x31                       @ Compare to '1'
        bleq    viewStrings                         @ Go to view strings

        @ Check if == 2
        cmp     r0,     #0x32                       @ Compare to '2'
        bleq    addString                           @ Go to add string

        @ Check if == 3
        cmp     r0,     #0x33                       @ Compare to '3'
        bleq    deleteString                        @ Go to delete strings

        @ Check if == 4
        cmp     r0,     #0x34                       @ Compare to '4'
        bleq    editString                          @ Go to edit strings

        @ Check if == 5
        cmp     r0,     #0x35                       @ Compare to '5'
        bleq    searchString                        @ Go to search strings

        @ Check if == 6
        cmp     r0,     #0x36                       @ Compare to '6'
        bleq    saveFile                            @ Go to save file

        @ Check if == 7
        cmp     r0,     #0x37                       @ Compare to '7'
        beq     mainMenuExit                        @ Go to exit

        @ Check if == FORCE QUIT
        cmp     r0,     #0x71                       @ Compare to 'q'
        beq     terminate                           @ Go to exit

        b       mainMenuLoop                        @ Reiterate


mainMenuExit:

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

.end
