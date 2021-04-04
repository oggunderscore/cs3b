.data
num1:	.word 0
num2:	.word 0
buffer: .space 6
enterX:	.asciz "Input x: "
enterY: .asciz "Input y: "

.text

	.global _start

_start:

	ldr 	r0, =enterX	@ Load string enterX
	bl	putstring	@ Print Str

	ldr 	r0, =buffer	@ Load the address of the buffer
	mov	r1, #0x6		@ Load buffer size of 6 bytes
	bl	getstring	@ Load input for getstring
	bl	ascint32	@ Convert from ascii to int
	ldr	r1, =num1	@ Load address of x into r1
	str	r0, [r1]	@ Store converted ascii from r1 into address of r0

	ldr	r0, =enterY
	bl	putstring

	ldr	r0, =buffer	@ Repeat for variable y
	mov	r1, #0x6
	bl	getstring
	bl	ascint32
	ldr	r1, =num2
	str	r0, [r1]

	ldr	r0, =num1	@ Load address of num1
	ldr	r1, [r0]	@ Load the value of num1 into r1
	ldr	r2, =num2	@ Load address of num2
	ldr	r3, [r2]	@ Load the value of num2 into r3
	cmp	r1, r3		@ Compare the two

	movlt	r0, r3		@ Move r3 into r0 if r1 < r3
	movge	r0, r1		@ Else move r1 into r0 if r1 >= r3

	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission
	.end
