.data
num1:	.word 0
num2:	.word 0
buffer: .space 6
enterX:	.asciz "Input x: "

.text

	.global _start

_start:

	ldr 	r0, =enterX	@ Load string enterX
	mov	r1, #0x200	@ load
	bl	putstring	@ Print Str

	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission
	.end
