
    .data

input:          .asciz    "input.txt"                       @ Input Text 
output:         .asciz    "output.txt"                      @ Ouput Text 
space:          .asciz    " "                                       @ Space String

sz1:            .asciz    "string #1 in the file: "
sz2:            .asciz    "\nstring #2 in the file: "
sz3:            .asciz    "\nDisplaying string #1: "
sz4:            .asciz    "\nDisplaying string #2: "
sz5:            .asciz    "\n\n\tSWAPPING..."
sz6:            .asciz    "\n\tConverting to Upper Case...\n"

newLine:        .asciz      "\n"

str1Ptr:        .word       0                       @ Str1Ptr
str2Ptr:        .word       0                       @ Str2Ptr
tempPtr:        .word       0

.text

    .global _start



_start:

    @ Start by opening the file and loading lines

    ldr     r0,     =input                      @ Load the text
    mov     r1,     #102                        @ Load flag
    ldr     r2,     =0644                       @ Read write perms

    mov     r7,     #5                          @ Open file code
    svc     0                                   @ Execute
    cpy     r10,    r0                          @ Store fileHandle

    @ Load line #1

    bl      loadLine                    @ get a line from the file 
    ldr     r1,     =str1Ptr            @ Load string 1 pointer
    str     r0,     [r1]                @ Store the address malloc'ed into r1

    @ load line #2

    bl      loadLine                    @ get a line from the file 
    ldr     r1,     =str2Ptr            @ Load string 2 pointer
    str     r0,     [r1]                @ Store the address malloc'ed into r1

    @ Print out both of the lines

    ldr     r0,     =sz1                @ Load string 1
    bl      putstring                   @ print

    ldr     r0,     =str1Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    ldr     r0,     =sz2                @ Load string 2
    bl      putstring                   @ print

    ldr     r0,     =str2Ptr            @ Load the str
    ldr     r0,     [r0]
    bl      putstring

    @ Print them again prior to swapping

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

    @ Induce beginning of swap. 1/3

    ldr     r0,     =str1Ptr            @ Load pointer here
    ldr     r0,     [r0]

    ldr     r1,     =tempPtr            @ Load temp
    str     r0,     [r1]                @ Store str1ptr

    @ 2/3

    ldr     r2,     =str2Ptr            @ Load str2 ptr
    ldr     r2,     [r2]                @ Deref
    ldr     r0,     =str1Ptr
    str     r2,     [r0]                @ str2Ptr -> into Str1Ptr

    @ 3/3

    ldr     r1,     =tempPtr            @ Load temp
    ldr     r1,     [r1]                @ Load str1ptr original
    ldr     r2,     =str2Ptr            @ Load str2ptr
    str     r1,     [r2]                @ Store str1 to str2ptr

    ldr     r0,     =sz6
    bl      putstring

    @ Swap complete

    @ toUpper()
    ldr     r1,     =str1Ptr            @ Load string1 to be toUpper()
    ldr     r0,     [r1]                @ Deref pointer to dynMem
    bl      String_toUpperCase          @ To upper it
    ldr     r1,     =str1Ptr            @ load address to store to
    str     r0,     [r1]                @ Store UPPER case data to pointer

    ldr     r0,     =str2Ptr            @ Load string2 to be toUpper()
    ldr     r0,     [r0]                @ Deref pointer to dynMem
    bl      String_toUpperCase          @ To upper it
    ldr     r1,     =str2Ptr            @ load address to store to
    str     r0,     [r1]                @ Store UPPER case data to pointer

    @ print results of toUpper()

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

    @ Start saving the strings

    ldr     r0,     =output                     @ load name
    mov     r1,     #102                        @ Load flag 102
    ldr     r2,     =0644                       @ load permissions

    mov     r7,     #5                          @ Open file code
    svc     0                                   @ Open actual file
    cpy     r8,     r0                          @ Store file handle to r8

    ldr     r0,     =str1Ptr            @ Load string
    ldr     r0,     [r0]                @ Deref
    bl      strLen                      @ get length
    cpy     r2,     r0                  @ Store that length in r2
    cpy     r0,     r8                  @ load fileHandle
    ldr     r1,     =str1Ptr            @ load string pointer
    ldr     r1,     [r1]                @ Deref

    mov     r7,     #4                          @ Load write flag
    svc     0                                   @ Write

    ldr     r1,     =newLine            @ load newline
    mov     r2,     #0x1                @ Size of 1
    cpy     r0,     r8                  @ load fileHandle

    mov     r7,     #4                          @ Load write flag
    svc     0                                   @ Write

    ldr     r0,     =str2Ptr            @ Load string
    ldr     r0,     [r0]                @ Deref
    bl      strLen                      @ get length
    cpy     r2,     r0                  @ Store that length in r2
    cpy     r0,     r8                  @ load fileHandle
    ldr     r1,     =str2Ptr            @ load string pointer
    ldr     r1,     [r1]                @ Deref

    mov     r7,     #4                          @ Load write flag
    svc     0                                   @ Write

    ldr     r1,     =newLine            @ load newline
    mov     r2,     #0x1                @ Size of 1
    cpy     r0,     r8                  @ load fileHandle

    mov     r7,     #4                          @ Load write flag
    svc     0                                   @ Write

    @ End of program
    b       terminate       @ Terminate Program
    .end
