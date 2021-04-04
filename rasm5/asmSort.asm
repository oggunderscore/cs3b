    .text

    .global asmBubbleSort

asmBubbleSort:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

asmBubbleSortProc:
    mov     r2,     #0x0                        @ current element num
    mov     r6,     #0x0                        @ num swaps

asmBubbleSortLoop:
    add     r3,     r2, #0x1                    @ Set r3 to next number index

    cmp     r3,     r1                          @ Check if end of data set
    bge     asmBubbleSortCheck                  @ Checking at end

    ldr     r4,     [r0, r2, lsl #2]            @ Get current value
    ldr     r5,     [r0, r3, lsl #2]            @ Get next value

    cmp     r4,     r5                          @ Compare two values

    strgt   r5,     [r0, r2, lsl #2]            @ if r4 > r5, set to next
    strgt   r4,     [r0, r3, lsl #2]            @ store to current
    addgt   r6,     r6, #0x1                    @ Inc swap counter
    mov     r2,     r3                          @ Go next element

    b       asmBubbleSortLoop                   @ Reiterate

asmBubbleSortCheck:
    cmp     r6,     #0x0                        @ Check if changed
    subgt   r1,     r1, #0x1                    @ If so, skip next
    bgt     asmBubbleSortProc                   @ If changed, iterate

asmBubbleSort_exit:                             
    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    