.equ    size, 100                               @ Size formatting for buffer
    .data

fileName:       .asciz    "output.txt"                              @ Input Text X
space:          .asciz    " "                                       @ Space String
writing:        .asciz    "Attempting to write to file... "         @ Writing 
reading:        .asciz    "Attempting to read the file... "         @ Reading
done:           .asciz    "Done"                                    @ Done
cat:            .asciz    "cat in the hat"                          @ String to write
n:              .byte    10                     @ Newline
length:         .word    0                      @ Value String Length
impBuffer:      .skip    size                   @ Input buffer
numBuffer:      .asciz    "000000000000000"     @ Number buffer

.text

    .global _start

terminate:

    ldr     r0,     =n                      @ Load newline
    bl      putch                           @ Print r0

    mov     r0,     #0                      @ Exit Code
    mov     r7,     #1                      @ Service Code
    svc     0                               @ Termination Permission

_start:

    @ Print writing text
    ldr     r0,     =writing                @ Load writing text
    bl      putstring                       @ Print Str

    @ Open file, create if doesnt exist
    ldr     r0,     =fileName               @ Load name of fileName
    mov     r1,     #102                    @ Load flag for create file if not exist
    ldr     r2,     =0644                   @ Give read/write perms?

    mov     r7,     #5                      @ Load open file code
    svc     0                               @ Execute create file if not there
    mov     r8,     r0                      @ Store filehandle

    @ Write string to file
    cpy     r0,     r8                      @ Copy r8 to r0
    ldr     r1,     =cat                    @ load string
    mov     r2,     #14                     @ Ideally get length of string and input number here

    mov     r7,     #4                      @ load write code
    svc     0                               @ Execute

    ldr     r0,     =done                   @ Load done
    bl      putstring                       @ print

    ldr     r0,     =n                      @ Load newline
    bl      putch                           @ Print nl

    @ Close the file
    mov     r7,     #6                      @ load close file code
    svc     0                               @ Execute

    @ Open file, create if doesnt exist
    ldr     r0,     =fileName               @ Load name of fileName
    mov     r1,     #102                    @ Load flag for create file if not exist
    ldr     r2,     =0644                   @ Give read/write perms?

    mov     r7,     #5                      @ Load open file code
    svc     0                               @ Execute create file if not there
    mov     r8,     r0                      @ Store filehandle

    @ Read to console
    ldr     r0,     =reading                @ Load reading text
    bl      putstring                       @ Print Str

    cpy     r0,     r8                      @ Copy r8 to r0
    ldr     r1,     =impBuffer              @ load input buffer
    ldr     r2,     =size                   @ Load as much as size

    mov     r7,     #3                      @ load write code
    svc     0                               @ Execute

    ldr     r0,     =done                   @ Load done
    bl      putstring                       @ print

    @ Close the file
    mov     r7,     #6                      @ load close file code
    svc     0                               @ Execute

    @ Print the result to console
    ldr     r0,     =n                      @ Load newline
    bl      putch                           @ Print NL

    mov     r0,     r1                      @ Move buffer result
    bl      putstring                       @ Call and print

    @ End of program
    b       terminate       @ Terminate Program
    .end
