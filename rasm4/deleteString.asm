    .data

b1:             .asciz          "["
b2:             .asciz          "]"
toDelete:       .asciz          "Enter the string index to delete: "
ooR:            .asciz          "ERROR: Index inputted out of range!\n"
deleting:       .asciz          "Deleting..."
done:           .asciz          "Done!"

    .text

    .global     deleteString

@ r2 = length of LL

@ Primary delete string menu option
deleteString:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =toDelete                   @ Load toDelete
    bl      putstring                           @ Print it

    cpy     r0,     r10                         @ load LL
    bl      LinkedList_len                      @ Get length of LL

    cpy     r2,     r0                          @ Copy length to r2
    @add     r2,     #0x30                       @ Add 30 hex to it to compare to input


    bl      getInput                            @ Get input from user
    bl      ascint32                            @ convert to number.


    cmp     r0,     r2                          @ Check to see if over
    bge     outOfRange                          @ Index out of range

    cpy     r2,     r0                          @ Preserve index
    push    {r0}
    b       deleteIndex                         @ Begin deletion

@ Assumes r0 contains value index to delete

deleteIndex:

    cpy     r1,     r0                          @ Copy value of index to delete to r1

    ldr     r0,     =deleting                   @ Load deleting
    bl      putstring                           @ Print

    cpy     r0,     r10                         @ Load LL
    cpy     r1,     r2                          @ Take index back
    pop     {r1}
    bl      LinkedList_pop_n                    @ Delete it.
    bl      free                                @ free underlying node data
    ldr     r0,     =done                       @ Load done
    bl      putstring                           @ Print

    b       deleteStringExit                    @ Exit

outOfRange:

    ldr     r0,     =ooR                        @ out of range
    bl      putstring                           @ Print it

    b       deleteStringExit                    @ Exit
    

deleteStringExit:
    bl      keyToContinue                       @ Pause funct

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call





    .end
    