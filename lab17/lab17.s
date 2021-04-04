.equ    size, 13                    @ Size formatting for buffer
    .data

aName:          .asciz    "Name: "              @ Text String
aClass:         .asciz    "Class: "             @ Text String
aLab:           .asciz    "Lab: "               @ Text String
aDate:          .asciz    "Date: "              @ Text String
name:           .asciz    "Kevin Nguyen"        @ Text String
class:          .asciz    "CS 3B"               @ Text String
lab:            .asciz    "Lab 17"              @ Text String
date:           .asciz    "10/13/2020"          @ Text String
impNum1:        .asciz    "Factorial of: "      @ Input Text X
space:          .asciz    " "                   @ Space String
equals:         .asciz    " = "                 @ Equals String
n:              .byte    10                     @ Newline
intX:           .word    0                      @ Value X
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

getInput:

    push 	{r4-r8, r10,r11}	@ Push preserved registers
    push    {lr}                @ Push Link register

    @ Var X

    ldr     r0,     =impNum1    @ Load string
    bl      putstring           @ Print r0

    ldr     r0,     =impBuffer  @ Load the input buffer address
    mov     r1,     #size       @ Load the size of the buffer
    bl      getstring           @ Load input into impBuffer
    bl      ascint32            @ Convert to int
    ldr     r1,     =intX       @ Load address of intA
    str     r0,     [r1]        @ Store converted value into deref r1

    pop     {lr}                @ Pop the link register
    pop     {r4-r8, r10,r11}	@ Pop preserved registers
    bx      lr                  @ Return call

printOutput:

    push 	{r4-r8, r10,r11}	@ Push preserved registers
    push    {lr}                @ Push Link register

    ldr     r0,     =space      @ Load print
    bl      putstring           @ Print Str
    ldr     r0,     =equals     @ Load print
    bl      putstring           @ Print Str

    ldr     r0,     =intX       @ Load the intX
    ldr     r0,     [r0]        @ Dereference Value for conversion
    ldr     r1,     =numBuffer  @ Load conversion buffer
    bl      intasc32            @ Convert to ascii
    mov     r0,     r1          @ Move the finished result into r0
    bl      putstring           @ Print

    pop     {lr}                @ Pop the link register
    pop     {r4-r8, r10,r11}	@ Pop preserved registers
    bx      lr


terminate:

    ldr     r0,     =n          @ Load newline
    bl      putch               @ Print r0

    mov     r0,     #0          @ Exit Code
    mov     r7,     #1          @ Service Code
    svc     0                   @ Termination Permission

_start:

    bl      printHeader         @ Print header
    bl      getInput            @ Get input from user

    ldr     r0,     =intX       @ Get X Address
    ldr     r0,     [r0]        @ Get value

    bl      fact                @ Use fact funct to calculate

    ldr     r1,     =intX       @ Get address to store
    str     r0,     [r1]        @ Store result into intX

    bl      printOutput         @ Print output algorithm

    b       terminate       @ Terminate Program
    .end
