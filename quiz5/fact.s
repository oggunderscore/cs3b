	.global fact

fact:
	push 	{R4-R11,LR}
	cmp	R1, #1
	bgt	recursion	@ return n * factorial(n-1)
	mov	R0, #1
	b	finish

recursion:
	mov	R4,R1
	sub	R1, #1
	bl	fact
	mov	R1,R4
	mul	R0, R1

finish:
	pop	{R4-R11, LR}
	bx	lr

.end
