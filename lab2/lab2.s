	.data
str:	.asciz "Kevin Nguyen\n" 

	.text
	.globl main

main:	stmfd	sp!,{lr}
	ldr	r0, =str
	bl	printf
	mov	r0, #0
	ldmfd	sp!,{lr}
	mov	pc, lr
