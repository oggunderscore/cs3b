    .text


strLength:

    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    ldr         r0,     =input                  @ Load user input for stringLength
    ldr         r0,     [r0]                    @ Dereference Pointer
    mov         r3,     #0x0                    @ Set counter to 0

    b           strLoop                         @ Start the loop

strLoop: 
    
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         strLengthExit                   @ Exit if end of line
    add         r3,     #0x1                    @ Increment string counter
    b           strLoop                         @ Iterate
    
strLengthExit:
    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    
    mov         r0,     r3                      @ Move final count to r0

    bx          lr                              @ Return call
    
    .end
