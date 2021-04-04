@ Purpose: Divide value in R0 by 2.
@
@ R0: Contains the integer to be divided by 2
@ LR: Contains the return address

@ Returned register contents:
@      R0: R0/2
@ AAPCS v2020Q2 Required registers are preserved.

        .data

        .global _div2           @ Provide program starting address to linker

        .text
_div2:
        @ Preserve AAPCS Required Registers
			push    {r4-r8, r10, r11}
           push    {sp}

           mov     r4, #-1
           mov     r5, #16
           mov     r6, #8
           mov     r7, #-2
           mov     r8, #4

           pop     {sp}
           pop     {r4-r8, r10, r11}

           bx      lr
        .end
