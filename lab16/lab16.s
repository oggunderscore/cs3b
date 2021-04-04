.equ	size, 13					@ Size formatting for buffer
	.data

aName:		.asciz	"Name: "			@ Text String
aClass:		.asciz	"Class: "			@ Text String
aLab:		.asciz	"Lab: "				@ Text String
aDate:		.asciz	"Date: "			@ Text String
name:		.asciz	"Kevin Nguyen"			@ Text String
class:		.asciz	"CS 3B"				@ Text String
lab:		.asciz	"Lab 16"			@ Text String
date:		.asciz	"10/11/2020"			@ Text String
impNum1:	.asciz	"Enter your first number: "	@ Input Text X
impNum2:	.asciz	"Enter your second number: "	@ Input Text Y
space:		.asciz	" "				@ Space String
slash:		.asciz	" / "				@ Slash String
charR:		.asciz	" R"				@ R String
equals:		.asciz	" = "				@ Equals String
n:		.byte	10				@ Newline
intX:		.word	0				@ Value X
intY:		.word	0				@ Value Y
impBuffer:	.skip	size				@ Input buffer
numBuffer:	.asciz	"000000000000000"		@ Number buffer

.text

	.global _start

printHeader:

	push	{lr}

	@ Stage 1 of Program - Print Header

	ldr	r0,	=aName		@ Load "Name: "
	bl	putstring		@ Print r0
	ldr	r0,	=name		@ Load var name
	bl	putstring		@ Print r0

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print r0

	ldr	r0,	=aClass		@ Load "Class: "
	bl	putstring		@ Print r0
	ldr	r0,	=class		@ Load var class
	bl	putstring		@ Print r0

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print r0

	ldr	r0,	=aLab		@ Load "Lab: "
	bl	putstring		@ Print r0
	ldr	r0,	=lab		@ Load var lab
	bl	putstring		@ Print r0

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print r0

	ldr	r0,	=aDate		@ Load "Date: "
	bl	putstring		@ Print r0
	ldr	r0,	=date		@ Load var date
	bl	putstring		@ Print r0

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print r0

	pop	{lr}
	bx	lr			@ Return to call

getInput:
	push	{lr}

	@ Stage 2 of program - Gather Input

	@ Var X

	ldr	r0,	=impNum1	@ Load string
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=intX		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Var Y

	ldr	r0,	=impNum2	@ Load string
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=intY		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	pop	{lr}
	bx	lr			@ Return call

printOutput:

	push	{lr}

	ldr	r0, =intX	@ Load address of X
	ldr	r0, [r0]	@ Dereference
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	ldr 	r0, =slash	@ Load print
	bl	putstring	@ Print Str

	ldr	r0, =intY	@ Load address of X
	ldr	r0, [r0]	@ Dereference
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	ldr 	r0, =equals	@ Load print
	bl	putstring	@ Print Str

	cpy	r0, r2		@ Load address of dividend
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	ldr 	r0, =charR	@ Load print
	bl	putstring	@ Print Str

	cpy	r0, r3		@ Load address of remainder
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	pop	{lr}
	bx	lr

_start:

	bl	printHeader		@ Print header
	bl	getInput		@ Get input from user

	ldr	r0,	=intX		@ Get X Address
	ldr	r0,	[r0]		@ Get value
	ldr	r1,	=intY		@ Get Y Address
	ldr	r1,	[r1]		@ Get value

	bl	idiv			@ Use idiv funct to divide

	mov	r2,	r0		@ Move dividend from r0 to r2
	mov	r3,	r1		@ Move remainder from r1 to r3

	bl	printOutput		@ Print output algorithm

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print r0

	mov 	r0, #0		@ Exit Code
	mov 	r7, #1		@ Service Code
	svc 	0		@ Termination Permission
	.end
