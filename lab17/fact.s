    .data
errorOverflowStr: .asciz  "ERROR: OVERFLOW OCCURRED WHILE MULTIPLYING" @ Error Message for overflow

    .text

factSetup:

    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    ldr         r1,     =intX                   @ Load user input for fact(x)
    ldr         r1,     [r1]                    @ Dereference Value
    cpy         r0,     r1                      @ Copy value into r0 from r2

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

fact:

    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register
    
    ldr         r2,     =intX                   @ Load user input for fact(x)
    ldr         r2,     [r2]                    @ Dereference Value
    cmp         r0,     r2                      @ Compare if this is first execution
    bleq        factSetup                       @ If first execution, setup vars

    @ Check if input is invalid
    
    cmp         r0,     #0x0                    @ Check if user input is 0
    moveq       r0,     #0x1                    @ Set result to 1
    beq         factExit                        @ Execute exit of this function
    
    cmp         r0,     #0x1                    @ Check if user input is 1
    moveq       r0,     #0x1                    @ Set result to 1
    beq         factExit                        @ Execute exit of this function

    cmp         r1,     #0x1                    @ Current Mult is 1
    beq         factExit                        @ Execute exit of this function

    @ Should input be valid, execute following
    
    sub         r1,     #0x1                	@ Subtract the n by 1

    
    smull       r0,     ip, r1, r0              @ Multiply n(n-1)

    cmp         ip,     r0, ASR #0x1F           @ Compare if the bits are the same
    bne         errorOverflow                   @ Execute Error

    bl          fact                            @ Reiterate


    
errorOverflow:

    ldr         r0,     =errorOverflowStr       @ Load str
    bl          putstring                       @ Print
    b           terminate			@ Termination
    
factExit:
    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register

    cmp         r2,     #0x0                    @ Compare that
    subne       r2,     #0x1                    @ Sub by 1 for every loop
    cmpne       r2,     #0x0                    @ Compare that
    bxeq        lr                              @ Return call
    bne         factExit                        @ Else Pop again
    
    .end
