.data
num1:		.word 	0
num2:		.word 	0
buffer: 	.space 	6		@ Input buffer
n:		.byte	10		@ New line buffer
enterX:		.asciz 	"x: "		@ Text String
enterY: 	.asciz 	"y: "		@ Text String
equals:		.asciz	" == "		@ Equals symbol
less:		.asciz	" < "		@ Less than symbol
greater:	.asciz	" > "		@ Greater than symbol
numBuffer:	.asciz	"000000000000"	@ Number buffer

.text

	.global _start

_start:
	@ Stage 1 - Getting input
	
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

	ldr	r4, =less	@ Load <

	ldr	r5, =equals	@ Load ==

	ldr	r6, =greater	@ Load >

	@ Stage 2 - Printing 1/2

	ldr	r0, =num1	@ Load address of num1
	ldr	r0, [r0]	@ Dereference
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	@ Stage 3 - Comparing the symbols

	ldr	r1, =num1	@ Load address of num1
	ldr	r1, [r1]	@ Load the value of num1 into r1
	ldr	r2, =num2	@ Load address of num2
	ldr	r2, [r2]	@ Load the value of num2 into r2

	cmp	r1, r2		@ Compare the two
	
	movlt	r0, r4		@ Move < into r0 if <
	moveq	r0, r5		@ Move == into r0 if =
	movgt	r0, r6		@ Move > into r0 if >

	bl	putstring	@ Print the conditional

	@ Stage 4 - Printing 2/2

	ldr	r0, =num2	@ Load address of num1
	ldr	r0, [r0]	@ Dereference
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	@ Stage 5 - Cleanup

	ldr	r0, =n		@ Load newline
	bl	putch		@ Print newline


	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission
	.end
