    .data

saving:         .asciz              "Saving file..."
done:           .asciz              "Done!\n"
fileName:       .asciz              "output.txt"
n:              .byte               10                          @ Newline char

    .text

    .global     saveFile


@ r0 = fileHandle / temp
@ r1 = copy of counter
@ r2 = temp
@ r3 = counter
@ r4 = size of LL
@ r5 = extra copy of counter
@ r8 = fileHandle copy

@ Primary save file menu option
saveFile:

    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    ldr     r0,     =saving                     @ Load saving
    bl      putstring                           @ Print it

    ldr     r0,     =fileName                   @ load name
    mov     r1,     #102                        @ Load flag 102
    ldr     r2,     =0644                       @ load permissions

    mov     r7,     #5                          @ Open file code
    svc     0                                   @ Open actual file
    cpy     r8,     r0                          @ Store file handle to r8


    cpy     r0,     r10                         @ Get LL               
    bl      LinkedList_len                      @ get size of LL
    cpy     r4,     r0

    mov     r3,     #0x0                        @ Load 0 into counter

    savingLoop:

        

        cmp     r3,     r4                          @ Compare to size
        bge     savingExit                          @ Exit once counter >= size

        cpy     r6,     r4                          @ Preserve flag

        cpy     r0,     r10                         @ Load address of LL
        cpy     r1,     r3                          @ Copy counter to r1
        bl      LinkedList_get_nth                  @ Returns the pointer to the *data

        ldr     r0,     [r0]                        @ Deref to become *data
        cpy     r1,     r0                          @ Store data to r1 

        cpy     r5,     r3                          @ Copy counter
        bl      strLen                              @ Get length of data
        cpy     r3,     r5                          @ Restore Counter

        mov     r2,     r0                          @ Move length to r2
        cpy     r0,     r8                          @ Move filehandle to r0

        mov     r7,     #4                          @ Load write flag
        svc     0                                   @ Write

        cpy     r0,     r8                          @ Move filehandle to r0
        ldr     r1,     =n                          @ load newline
        mov     r2,     #0x1                        @ Load size of newline

        sub     r6,     r3                          @ if last line == 1
        cmp     r6,     #0x1                        @ Compare if == last line
        svcne   0                                   @ Write

        add     r3,     #0x1                        @ increment counter

        b       savingLoop                          @ Iterate



savingExit:
    cpy     r0,     r8                          @ Copy file handle to r0

    mov     r7,     #6                          @ Load closing flag
    svc     0                                   @ Close file

    ldr     r0,     =done                       @ Load done
    bl      putstring                           @ Yay

    bl      keyToContinue                       @ Pause funct

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call


    .end
    