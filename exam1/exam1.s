 .equ	size, 13

	.data			@ Data directive for variables and constants
aName:		.asciz	"Name: "		@ Header Information
aClass:		.asciz	"Class: "		@ Header Information
aLab:		.asciz	"Lab: "			@ Header Information
aDate:		.asciz	"Date: "		@ Header Information
name:		.asciz	"Kevin Nguyen"		@ Header Data
class:		.asciz	"CS 3B"			@ Header Data
lab:		.asciz	"Exam 1"		@ Header Data
date:		.asciz	"9/28/2020"		@ Header Data
iX:		.word	0			@ Variable X
iY:		.word	0			@ Variable Y
sum:		.word	0			@ Variable total result
enterX:		.asciz	"Enter x: "		@ String for input X
enterY:		.asciz	"Enter y: "		@ String for input Y
charPb:		.asciz	"("			@ Char Resource
charPe:		.asciz	")"			@ Char Resource
charPlus:	.asciz	"+"			@ Char Resource
charEquals:	.asciz	"="			@ Char Resource
char2:		.asciz	"2"			@ Char Resource
space:		.asciz	" "			@ Char Resource
impBuffer:	.skip	size			@ Input Buffer
numBuffer:	.asciz	"000000000000000"	@ Potential buffer of the number inputted
n:		.byte	10			@ New Line Buffer

.text						@ Text directive

	.global _start				@ Starting point directive

_start:						@ Starting point entry

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
	bl	putch			@ Print r0

	@ Stage 2 of program - Gather Input

	@ Var X

	ldr	r0,	=enterX		@ Load "Enter x: "
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=iX		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Var Y

	ldr	r0,	=enterY		@ Load "Enter a whole number: "
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=iY		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Stage 3 of Program - Calculation

	ldr	r0,	=iY		@ Load iY address
	ldr	r1,	[r0]		@ Get value from address

	add	r1,	r1		@ Y = Y + Y (aka y*2)

	ldr	r2,	=iX		@ Load iX address
	ldr	r3,	[r2]		@ Get value from address

	add	r1,	r3		@ r1 = 2y + x
	add	r1,	r1		@ r1 = r1 + r1 (aka 2(x + 2y) )

	ldr	r2,	=sum		@ Load sum address
	str	r1,	[r2]		@ Store sum into [r2] (sum)

	@ Stage 4 of Program - Displaying Calculation and addresses

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print newline

	ldr	r0,	=char2		@ Load 2 into r0
	bl	putch			@ Print 2

	ldr	r0,	=charPb		@ Load "("
	bl	putstring		@ Print "("

	ldr	r1,	=iX		@ Load address of iX
	ldr	r0,	[r1]		@ Load value of iX into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print iX

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	ldr	r0,	=charPlus	@ Load "+"
	bl	putstring		@ Print "+"
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "

	ldr	r0,	=char2		@ Load 2 into r0
	bl	putch			@ Print 2

	ldr	r0,	=charPb		@ Load "("
	bl	putstring		@ Print "("

	ldr	r1,	=iY		@ Load address of iY
	ldr	r0,	[r1]		@ Load value of iY into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print iY

	ldr	r0,	=charPe		@ Load ")"
	bl	putstring		@ Print ")"
	bl	putstring		@ Print ")"

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	ldr	r0,	=charEquals	@ Load "="
	bl	putstring		@ Print "="
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "

	ldr	r1,	=sum		@ Load address of sum
	ldr	r0,	[r1]		@ Load value of sum into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print sum

	@ Stage 5 of Program - Cleanup

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print newline
	bl	putch			@ Print newline

	mov 	r0,	#0		@ Exit Code
	mov	r7,	#1		@ Service Code
	svc	0			@ Termination Permission
	.end				@ End Program
