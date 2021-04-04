.equ    size, 100                               @ Size formatting for buffer
    .data

aName:          .asciz    "Name: "              @ Text String
aClass:         .asciz    "Class: "             @ Text String
aLab:           .asciz    "Lab: "               @ Text String
aDate:          .asciz    "Date: "              @ Text String
name:           .asciz    "Kevin Nguyen"        @ Text String
class:          .asciz    "CS 3B"               @ Text String
lab:            .asciz    "Lab 18"              @ Text String
date:           .asciz    "10/31/2020"          @ Text String
fileName:       .asciz    "file.txt"            @ Input Text X
space:          .asciz    " "                   @ Space String
writing:        .asciz    "Attempting to write to file..."                 @ Writing 
reading:        .asciz    "Attempting to read the file..."                 @ Reading
n:              .byte    10                     @ Newline
length:         .word    0                      @ Value String Length
impBuffer:      .skip    size                   @ Input buffer
numBuffer:      .asciz    "000000000000000"     @ Number buffer

.text

    .global _start

printHeader:

    push    {r4-r8, r10,r11}	@ Push preserved registers
    push    {lr}                @ Push Link register

    ldr     r0,     =aName      @ Load "Name: "
    bl      putstring           @ Print r0
    ldr     r0,     =name       @ Load var name
    bl      putstring           @ Print r0

    ldr     r0,     =n          @ Load newline
    bl      putch               @ Print r0

    ldr     r0,     =aClass     @ Load "Class: "
    bl      putstring           @ Print r0
    ldr     r0,     =class      @ Load var class
    bl      putstring           @ Print r0

    ldr     r0,     =n          @ Load newline
    bl      putch               @ Print r0

    ldr     r0,     =aLab       @ Load "Lab: "
    bl      putstring           @ Print r0
    ldr     r0,     =lab        @ Load var lab
    bl      putstring           @ Print r0

    ldr     r0,     =n          @ Load newline
    bl      putch               @ Print r0

    ldr     r0,     =aDate      @ Load "Date: "
    bl      putstring           @ Print r0
    ldr     r0,     =date       @ Load var date
    bl      putstring           @ Print r0

    ldr     r0,     =n          @ Load newline
    bl      putch               @ Print r0

    pop     {lr}                @ Pop the link register
    pop 	{r4-r8, r10,r11}	@ Pop preserved registers
    bx      lr                  @ Return to call

terminate:

    ldr     r0,     =n          @ Load newline
    bl      putch               @ Print r0

    mov     r0,     #0          @ Exit Code
    mov     r7,     #1          @ Service Code
    svc     0                   @ Termination Permission

_start:

    ldr     r0,     =writing    @ Load writing text
    bl      putstring           @ Print Str

    ldr     r0,     =fileName               @ Load name of fileName
    ldr     r1,     #0100                   @ Load flag for create file if not exist
    ldr     r2,     #0644                   @ Give read/write perms?

    mov     r7,     #0x5                    @ Load open file code
    svc     0                               @ Execute create file if not there

    ldr     r0,     =reading    @ Load reading text
    bl      putstring           @ Print Str

    b       terminate       @ Terminate Program
    .end
