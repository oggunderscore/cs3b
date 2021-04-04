.data
szX:	.asciz "10"
szY:	.asciz "15"
iX:	.word 0
iY:	.word 0
iSum:	.word 0

.text

	.global _start

_start:
	ldr	r0, =szX	@ Load szX into r0
	bl	ascint32 	@ Should convert szX to the word val and into r0
	ldr	r1, =iX		@ Load address of iX into r1
	str	r0, [r1]	@ Store r0 into iX (value)

	ldr	r0, =szY	@ Repeat of Step 1 with szX
	bl	ascint32
	ldr	r1, =iY
	str	r0, [r1]

	ldr	r0, =iX		@ Load address of iX into r0
	ldr 	r1, [r0]	@ Load value of address from r0 into r1
 	ldr	r2, =iY		@ Load address of iY into r2
	ldr	r3, [r2]	@ Load value of address from r2 into r3

	add 	r1, r3		@ r1 = r1 + r3; Logic to add
	ldr 	r4, =iSum	@ Load address of iSum into r4
	str	r1, [r4]	@ Store sum value from r1 into address of r4 (which is iSum)

	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission
	.end
