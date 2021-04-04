.equ                    size,       100                         @ Max Size
    .data

exiting:                .asciz      "\nProgram exiting...\n\n"                 @ Input text for menu
inputText:              .asciz      "\nInput: "                 @ Input text for menu
continue:               .asciz      "\nPress ENTER to return to main menu..."                 @ Continue text

numberBuffer:           .asciz      "00000000000000000"         @ Max number buffer
inputBuffer:            .skip       size                        @ Input buffer of size
n:                      .byte       10                          @ Newline char

    .text

    .global     newLine
    .global     clearScreen
    .global     printNum
    .global     printNumRaw
    .global     terminate
    .global     keyToContinue
    .global     getCharInput
    .global     getInput
    .global     inputText

@ Called to obtain a menu choice option
getCharInput:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =inputBuffer                @ Load input buffer
    mov     r1,     #size                       @ Load size of input buffer
    bl      getstring                           @ Get input

    ldrb    r0,     [r0]                        @ Deref value

    @ TODO: Check for input here in r0

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

@ Called to obtain a menu choice option
getInput:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =inputBuffer                @ Load input buffer
    mov     r1,     #size                       @ Load size of input buffer
    bl      getstring                           @ Get input

    @ TODO: Check for input here in r0

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

@ Press any key to contnue
keyToContinue:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =continue                   @ load continue text
    bl      putstring                           @ print

    bl      getInput                            @ Get input from user

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call


@ Prints loaded number, assumes r0 contains address to number
printNum:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     [r0]                        @ Dereference self
    ldr     r1,     =numberBuffer               @ Load number buffer
    bl      intasc32                            @ Convert it
    mov     r0,     r1                          @ Send result to r0
    bl      putstring                           @ Print it

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

@ Prints loaded number, assumes r0 contains address to number
printNumRaw:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r1,     =numberBuffer               @ Load number buffer
    bl      intasc32                            @ Convert it
    mov     r0,     r1                          @ Send result to r0
    bl      putstring                           @ Print it

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

@ Print newline
newLine:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =n                          @ Load newline char
    bl      putch                               @ Print it

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

@ Clear the screen funct
clearScreen:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline
    bl      newLine                             @ Print newline

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call


@ Termination function for program
terminate:

    bl      clearScreen                         @ Clear

    ldr     r0,     =exiting                    @ Load exiting string
    bl      putstring                           @ Print it

    mov     r0,     #0
    mov     r7,     #1
    svc     0


