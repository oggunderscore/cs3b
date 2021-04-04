    .data

b1:             .asciz          "["
b2:             .asciz          "]"
stringToAdd:    .asciz          "Add String > "
success:        .asciz          "\nString successfully added to list."
menu:           .asciz          "Input from Keyboard / from File (a/b): "
fileName:       .asciz          "input.txt"
imported:       .asciz          "All Strings successfully imported. "
impBuffer:      .skip           4

    .text

    .global     addString


@ Primary add string menu option
addString:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    addStringLoop:
        ldr     r0,     =menu                       @ Input 2
        bl      putstring                           @ Print

        bl      getCharInput                        @ Get choice

        cmp     r0,     #0x61                       @ Check if 'a'
        beq     fromKeyboard

        cmp     r0,     #0x62                       @ Check if 'b'
        beq     fromText

        b       addStringLoop                           @ Else case

fromKeyboard:
    @bl      clearScreen                         @ Clear screen 


    ldr     r0,     =stringToAdd                @ Print line
    bl      putstring                           @ Print

    bl      getInput                            @ Get input from user

    bl      String_copy                             @ Duplicate it dynamically

    mov     r1,     r0                          @ Move data to r1

    cpy     r0,     r10                         @ Copy LL address to r0

    bl      LinkedList_push                     @ Insert to end

    ldr     r0,     =success                    @ Success
    bl      putstring                           @ Print

    b       addStringExit                       @ Go back to mainMenu

    @ r0 = fileHandle
    @ r1 = Char imported from file
    @ r2 = Num bytes
    @ r3 = Address of Buffer
    @ r4 = Counter Offset
    @ r8 = Copy of filehandle

addStringExit:
    bl      keyToContinue                       @ Pause funct

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

fromText:

    mov     r0,     #100                        @ Size 100
    mov     r1,     #0x1                        @ Element byte size 1
    bl      calloc                              @ Create stringBuffer of size 100
    cpy     r3,     r0                          @ Copy address of stringBuffer to r3

    ldr     r0,     =fileName                   @ Load the text
    mov     r1,     #102                        @ Load flag
    ldr     r2,     =0644                       @ Read write perms

    mov     r7,     #5                          @ Open file code
    svc     0                                   @ Execute
    cpy     r8,     r0                          @ Store fileHandle

    mov     r4,     #0x0                        @ Set counter to 0


    @ Should fall through.

    fileIterator:
        cpy         r0,     r8                  @ Copy file handle
        ldr         r1,     =impBuffer          @ Size 1 buffer
        mov         r2,     #0x1                @ Load 1 byte

        mov         r7,     #3                  @ Load read code
        svc         0                           @ Read 1 char into r1 (impBuffer)

        ldr         r1,     [r1]                @ Deref into raw value

        cmp         r0,     #0x0                @ Check if EOF
        beq         finalReturn                 @ Exit function

        cmp         r1,     #10                 @ Check if EOL
        beq         iteratorReturn              @ Go to makeString

        str         r1,     [r3, r4]            @ Store into buffer with offset r2
        add         r4,     #0x1                @ Increment offset

        b           fileIterator                @ Recurse

iteratorReturn:
    bl      makeString                          @ Create String

    mov     r4,     #0x0                        @ Reset char counter

    b       fileIterator                        @ Return back to fileIterator


makeString:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    cpy     r0,     r3                          @ Load address of completed string from file
    cpy     r5,     r3                          @ Preserve r3
    bl      String_copy                         @ Induce String_copy to create a new string dynamically

    mov     r4,     r0                          @ Move data address to r1

    cpy     r1,     r4                          @ Copy from r4 to r1 then push

    cpy     r0,     r10

    bl      LinkedList_push                     @ Make into linked list node


    
    mov     r0,     #100                        @ Size 100
    mov     r1,     #0x1                        @ Element byte size 1
    bl      calloc                              @ Create stringBuffer of size 100

    mov     r3,     r0                          @ Give r3 new address



    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call

finalReturn:
    mov     r5,     #0x0

    bl      makeString                          @ Make last string

    b       fromTextExit                        @ Exit then

fromTextExit:
    ldr     r0,     =imported                   @ Load str
    bl      putstring                           @ Print

    b       addStringExit                       @ Exit to main menu and pop

    .end
    