    .data

b1:             .asciz          "["
b2:             .asciz          "]"
toEdit:         .asciz          "Enter the string index to edit: "
newString:      .asciz          "New String > "
ooR:            .asciz          "ERROR: Index inputted out of range!\n"
editing:        .asciz          "Making changes..."
done:           .asciz          "Done!"

    .text

    .global     editString


@ Primary edit string menu option
editString:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =toEdit                     @ Load toDelete
    bl      putstring                           @ Print it

    cpy     r0,     r10                         @ load LL
    bl      LinkedList_len                      @ Get length of LL

    cpy     r2,     r0                          @ Copy length to r2
    @add     r2,     #0x30                       @ Add 30 hex to it to compare to input


    bl      getCharInput                        @ Get input from user

    sub     r0,     #0x30                       @ Sub 30 hex to match length decimal value

    cmp     r0,     r2                          @ Check to see if over
    bge     outOfRange                          @ Index out of range

    cpy     r4,     r0                          @ Preserve index to del

    @ now get input from user

    ldr     r0,     =newString                  @ Print line
    bl      putstring                           @ Print

    bl      getInput                            @ Get input from user

    bl      String_copy                             @ Duplicate it dynamically

    cpy     r1,     r2                          @ Copy r2 to r1

    @ At this point, r0 contains a pointer to new string, and r1 contains index to replace

    b       editIndex                           @ Begin deletion

@ r0 = Pointer to LL
@ r1 = Index to edit
@ r2 = Length of LL
@ r3 = new *data


editIndex:

    cpy     r5,     r0                          @ Copy new *data to r3

    ldr     r0,     =editing                    @ Making changes
    bl      putstring                           @ print

    cpy     r0,     r10                         @ Load LL
    cpy     r1,     r4                          @ Restore index

    bl      LinkedList_get_nth                  @ Get nth data

    push    {r0}                                @ push it
    bl      getNodeData                         @ Get the data
    bl      free                                @ FREE THE DATA!
    pop     {r0}                                @ pop r0

    cpy     r1,     r5                          @ Load new *data to r1
    bl      setNodeData                         @ Store *data into r0 node

    ldr     r0,     =done                       @ Done!
    bl      putstring                           @ Print

    b       editStringExit

outOfRange:

    ldr     r0,     =ooR                        @ out of range
    bl      putstring                           @ Print it

    b       editStringExit                      @ Exit

editStringExit:

    bl      keyToContinue                       @ Pause funct

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

    .end
    