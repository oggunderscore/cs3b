
    .text

	.global         _start


@ 
template:
    push    {r4-r8, r10, r11}                   @ Push preserved registers
    push    {lr}                                @ Push linked register

    

    pop     {lr}                                @ Pop linked register
    pop     {r4-r8, r10, r11}                   @ Pop preserved registers
    bx      lr                                  @ Return call



_start:

    bl      LinkedList                          @ Create LL
    mov     r10,    r0                          @ Store that in r7

    bl      mainMenu                            @ Go to mainMenu

    b       terminate                           @ Termination of program
	.end
