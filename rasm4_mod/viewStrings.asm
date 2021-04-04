    .data

b1:             .asciz          "["
b2:             .asciz          "] "
empty:          .asciz          "ERROR: List is empty!\n"

    .text

    .global     viewStrings

@ r0 = Pointer to LL
@ r1 = Passed X to get nth
@ r2 = Length of LL
@ r3 = Counter 

@ Primary view strings menu option
viewStrings:

@ Begin looping and printing strings

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    mov     r3,     #0x0                        @ Load 0 counter
    cpy     r0,     r10                         @ load LL
    bl      LinkedList_len                      @ Get length
    cpy     r2,     r0                          @ Move length to r2

    cmp     r0,     #0x0                        @ If Len == 0
    beq     errorEmptyList                      @ Exit

    viewLoop:
        cmp     r3,     r2                      @ Compare index
        bge     viewStringsExit                 @ Exit this area


        ldr     r0,     =b1                     @ Load [
        bl      putstring                       @ Print ]
        cpy     r0,     r3                      @ Load x
        bl      printNumRaw                     @ Print x
        ldr     r0,     =b2                     @ Load ]
        bl      putstring                       @ Print ]

        cpy     r0,     r10                     @ Load LL
        cpy     r1,     r3                      @ Load x
        bl      LinkedList_get_nth              @ Get Pointer to Data

        ldr     r0,     [r0]                    @ Deref LL Pointer to get Data pointer
        bl      putstring                       @ Print the string in list

        bl      newLine                         @ Newline

        add     r3,     #0x1                    @ Increment counter

        b       viewLoop                        @ iterate

errorEmptyList:

    ldr     r0,     =empty                      @ Load str
    bl      putstring                           @ Print

    b       viewStringsExit                     @ exit funct

    
viewStringsExit:

    bl      keyToContinue                       @ Pause funct

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call




    .end
    