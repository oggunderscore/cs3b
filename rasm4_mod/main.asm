.equ    size, 256                               @ Size formatting for buffer
    .data

input:          .asciz    "input.txt"                       @ Input Text 
output:         .asciz    "output.txt"                      @ Ouput Text 
space:          .asciz    " "                                       @ Space String

sz1:            .asciz    "string #1 in the file: "
sz2:            .asciz    "\nstring #2 in the file: "
sz3:            .asciz    "\nDisplaying string #1: "
sz4:            .asciz    "\nDisplaying string #2: "
sz5:            .asciz    "\n\tSWAPPING..."
sz6:            .asciz    "\n\tConverting to Upper Case...\n"

n:              .byte    10                     @ Newline
length:         .word    0                      @ Value String Length
impBuffer:      .skip       size                    @ Input buffer
strBuffer:      .skip       size                    @ Input buffer

str1Ptr:        .word       0                       @ Str1Ptr
str2Ptr:        .word       0                       @ Str2Ptr
tempPtr:        .word       0

.text

    .global _start

terminate:

    ldr     r0,     =n                      @ Load newline
    bl      putch                           @ Print r0

    mov     r0,     #0                      @ Exit Code
    mov     r7,     #1                      @ Service Code
    svc     0                               @ Termination Permission

strLen:
        // preserve AAPCS registers
        push {r4-r8, r10,r11}
        push {lr}
        mov r3, #0              // r3 = counter
_string_len_top:                // while char != NULL {
        ldrb r4, [r0, r3]       //  load byte from str ptr in r0 using r3 as register offset
        cmp r4, #0              //  check if byte is NULL
        beq _string_len_exit    //  if (char == NULL) {break}
        add r3, r3, #1          //  counter += 1
        b _string_len_top       // }


_string_len_exit:
        cpy r0, r3  // persist counter to r0 as return value
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr


String_copy:
        // preserve AAPCS registers
        push {r4-r8, r10,r11}
        push {lr}
        cpy r4, r0                          // r4 := originString = r0
        bl strLen                           // r0 := strLen(r0)
        add r0, #1
        cpy r5, r0                          // r5 := length = strLen(r0)
        /* void *calloc(size_t nmemb, size_t size) */
        /*        The calloc() function allocates memory for an array of nmemb elements
                  of size bytes each and returns a pointer to the allocated memory.
                  The memory is set to zero. */
                    // r0 already contains length, which is the number of requisite members
        mov r1, #1  // each element is 1 byte long.
        bl calloc   // calloc(r0, 1); // allocate r0 := len(originString) bytes of memory
        // r0 := new_string
        b _string_copy_loop_init    // move to next step.
_string_copy_loop_init:
        mov r1, #0  // r1 := i = 0
_string_copy_loop_top:
        ldrb r7, [r4, r1]           //  load byte from originString[i]
        cmp r7, #0                  //  check if byte is NULL
        beq _string_copy_exit       //  if (char == NULL) {break}
        strb r7, [r0,r1]            // new_string[i] = originString[i]
        add r1, r1, #1              //  counter += 1
        b _string_copy_loop_top     // }

_string_copy_exit:
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr


toUpper:
    sub         r1,     #0x20                   @ Sub 32 to current val to turn it lowercase
    add         r3,     r4, r2                  @ r3 = Base Address of Str + Offset Iterator = Address of Char
    strb        r1,     [r3]                    @ Store that back into where r0 is with counter
    add         r2,     #0x1                    @ Increment Index Counter
    b           String_toUpperCase_loop


String_toUpperCase:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    bl          String_copy                     @ Dynamically Allocate it

    cpy         r4,     r0                      @ Copy address

    mov         r2,     #0x0                    @ Reset Counters

    b           String_toUpperCase_loop         @ Start Loop

String_toUpperCase_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_toUpperCase_exit         @ Exit if end of line

    mov         r3,     #0x0                    @ Reset Flag

    cmp         r1,     #0x61                   @ If >= 'a'
    addge       r3,     #0x1                    @ Inc flag by 1
    cmp         r1,     #0x7A                   @ Check if <= 'z'
    addle       r3,     #0x1                    @ Inc flag by 1

    cmp         r3,     #0x2                    @ If both pass, then it is lowercase, make upper
    beq         toUpper

    add         r2,     #0x1                    @ Increment Index Counter
    b           String_toUpperCase_loop         @ Else, iterate and loop

String_toUpperCase_exit:
    mov         r0,     r4                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Registers
    bx          lr                              @ Return call


loadLine:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register



    ldr     r3,     =strBuffer                  @ Load buffer for string to be stored temp

    mov     r4,     #0x0                        @ Set counter to 0

    lineIterator:

        cpy         r0,     r10                 @ Copy file handle
        ldr         r1,     =impBuffer          @ Size 1 buffer
        mov         r2,     #0x1                @ Load 1 byte

        mov         r7,     #3                  @ Load read code
        svc         0                           @ Read 1 char into r1 (impBuffer)

        ldr         r1,     [r1]                @ Deref into raw value

        cmp         r1,     #10                 @ Check if EOL
        beq         loadExit                    @ Go to return the malloc'ed

        str         r1,     [r3, r4]            @ Store into buffer with offset r2
        add         r4,     #0x1                @ Increment offset

        b           lineIterator

loadExit:
        cpy     r0,     r3                      @ Copy to r0

        bl      String_copy                     @ Dynamically allocate

        pop     {lr}                                @ Pop linked register
        pop     {r4-r8, r10, r11}                   @ Pop preserved registers
        bx      lr                                  @ Return call



_start:

    ldr     r0,     =input                      @ Load the text
    mov     r1,     #102                        @ Load flag
    ldr     r2,     =0644                       @ Read write perms

    mov     r7,     #5                          @ Open file code
    svc     0                                   @ Execute
    cpy     r10,    r0                          @ Store fileHandle

    bl      loadLine                    @ get a line from the file 
    ldr     r1,     =str1Ptr            @ Load string 1 pointer
    str     r0,     [r1]                @ Store the address malloc'ed into r1

    bl      loadLine                    @ get a line from the file 
    ldr     r1,     =str2Ptr            @ Load string 2 pointer
    str     r0,     [r1]                @ Store the address malloc'ed into r1

    ldr     r0,     =sz1                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str1Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    ldr     r0,     =sz2                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str2Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    ldr     r0,     =sz3                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str1Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    ldr     r0,     =sz4                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str2Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    ldr     r0,     =sz5
    bl      putstring

    mov     r0,  #0
    mov     r1,  #0
    mov     r2,  #0
    mov     r3,  #0

    ldr     r0,     =str1Ptr            @ Load pointer here
    ldr     r0,     [r0]

    ldr     r1,     =tempPtr            @ Load temp
    str     r0,     [r1]                @ Store str1ptr

    mov     r0,  #0
    mov     r1,  #0
    mov     r2,  #0
    mov     r3,  #0

    ldr     r2,     =str2Ptr            @ Load str2 ptr
    ldr     r2,     [r2]                @ Deref
    ldr     r0,     =str1Ptr
    str     r2,     [r0]                @ str2Ptr -> into Str1Ptr

    mov     r0,  #0
    mov     r1,  #0
    mov     r2,  #0
    mov     r3,  #0

    ldr     r1,     =tempPtr            @ Load temp
    ldr     r1,     [r1]                @ Load str1ptr original
    ldr     r2,     =str2Ptr            @ Load str2ptr
    str     r1,     [r2]                @ Store str1 to str2ptr

    ldr     r0,     =sz6
    bl      putstring

    @ TODO: toUpper()


    ldr     r0,     =sz3                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str1Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    ldr     r0,     =sz4                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str2Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring



    @ End of program
    b       terminate       @ Terminate Program
    .end
