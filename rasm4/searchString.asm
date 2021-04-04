    .data

b1:             .asciz          "["
b2:             .asciz          "] "
toSearch:       .asciz          "Search > "
searching:      .asciz          "Searching..."
notFound:       .asciz          "\nERROR: String not found in database.\n"
invalid:        .asciz          "\nERROR: Invalid input.\n"
found:          .asciz          "FOUND\n"

    .text

    .global     searchString
    .global     errorNotFound
    .global     errorInvalid
    .global     printLoc


@ Primary search string menu option
searchString:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =toSearch                   @ Load String
    bl      putstring                           @ Print it
    bl      getInput                            @ Get input from user into r0

    @ Insert check for invalid
    ldrb    r1,     [r0]                        @ Load data into r1
    cmp     r1,     #0x0                        @ Check for "RETURN"
    beq     errorInvalid                        @ Exit to invalid

    cpy     r1,     r0                          @ Preserve input
    push {r1}                                   @ cache user input

    ldr     r0,     =searching                  @ Searching...
    bl      putstring                           @ Print
    bl      newLine                             @ Newline
    pop {r1}                                    @ cache user input
    cpy r0, r10                                 @ restore LL
    ldr r0, [r0, #0]                            @ r0 := ll->head
    bl      walk_ll_substrings

    /* Testing code.
    mov     r0,     #0x0
    bl      printLoc
    mov     r0,     #0x1
    bl      printLoc

    mov     r0,     #1                         @ TEST CASE
    */

    @ If returns 0 means not found
    cmp     r0,     #0x0                          @ If returns 0
    beq     errorNotFound                       @ Execute not found

    @ if returns 1 means something found
    cmp     r0,     #0x1                        @ Check if 1
    beq     searchStringExit                    @ Exit code

errorNotFound:
    ldr     r0,     =notFound                   @ Not found
    bl      putstring                           @ Print it

    b       searchStringExit                    @ Abort

errorInvalid:
    ldr     r0,     =invalid                    @ Invalid input
    bl      putstring                           @ Print it

    b       searchStringExit                    @ Abort

@ Prints "[x] <String here>" if found
@ ARGUMENTS
@ r0 = Index of Node in list to print
@ RETURNS
@ void
@ void printLoc(int); 
printLoc:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    cpy     r2,     r0                          @ Preserve index num

    bl      newLine                             @ Newline

    ldr     r0,     =b1                         @ Load [
    bl      putstring                           @ Print
    cpy     r0,     r2                          @ Recall index num
    bl      printNumRaw                         @ Print number
    ldr     r0,     =b2                         @ Load ]
    bl      putstring                           @ Print

    cpy     r0,     r10                         @ Get LL
    cpy     r1,     r2                          @ Put index in r1
    bl      LinkedList_get_nth                  @ Get the *node at index

    ldr     r0,     [r0]                        @ Deref to get *data
    bl      putstring                           @ Print it

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

searchStringExit:

    bl      keyToContinue                       @ Pause funct

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

    .end