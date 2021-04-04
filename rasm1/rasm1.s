.equ	size, 13

	.data			@ Data directive for variables and constants
aName:		.asciz	"Name: "
aClass:		.asciz	"Class: "
aLab:		.asciz	"Lab: "
aDate:		.asciz	"Date: "
name:		.asciz	"Kevin Nguyen"
class:		.asciz	"CS 3B"
lab:		.asciz	"RASM1"
date:		.asciz	"9/16/2020"
intA:		.word	0
intB:		.word	0
intC:		.word	0
intD:		.word	0
impWholeNum:	.asciz	"Enter a whole number: "
charPb:		.asciz	"("
charPe:		.asciz	")"
charPlus:	.asciz	"+"
charEquals:	.asciz	"="
charMinus:	.asciz	"-"
addressBuffer:	.asciz	"00000000"
space:		.asciz	" "
addressPrefix:	.asciz	"0x"
impBuffer:	.skip	size
n:		.byte	10
sum1:		.word	0
sum2:		.word	0
sum3:		.word	0
numBuffer:	.asciz	"000000000000000"
addressOutput:	.asciz	"The addresses of the 4 ints:"

.text

	.global _start

_start:

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

	@ Var A

	ldr	r0,	=impWholeNum	@ Load "Enter a whole number: "
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=intA		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Var B

	ldr	r0,	=impWholeNum	@ Load "Enter a whole number: "
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=intB		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Var C

	ldr	r0,	=impWholeNum	@ Load "Enter a whole number: "
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=intC		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Var D

	ldr	r0,	=impWholeNum	@ Load "Enter a whole number: "
	bl	putstring		@ Print r0

	ldr	r0,	=impBuffer	@ Load the input buffer address
	mov	r1,	#size		@ Load the size of the buffer
	bl	getstring		@ Load input into impBuffer
	bl	ascint32		@ Convert to int
	ldr	r1,	=intD		@ Load address of intA
	str	r0,	[r1]		@ Store converted value into deref r1

	@ Stage 3 of Program - Calculation

	ldr	r0,	=intA		@ Load intA address
	ldr	r1,	[r0]		@ Get value from address
	ldr	r2,	=intB		@ Load intB address
	ldr	r3,	[r2]		@ Get value from address

	add	r1,	r3		@ A = A + B

	ldr	r4,	=sum1		@ Load sum1 address
	str	r1,	[r4]		@ Store A+B into sum1

	ldr	r0,	=intC		@ Load intC address
	ldr	r1,	[r0]		@ Get value from address
	ldr	r2,	=intD		@ Load intD address
	ldr	r3,	[r2]		@ Get value from address

	add	r1,	r3		@ C = C + D

	ldr	r4,	=sum2		@ Load sum2 address
	str	r1,	[r4]		@ Store C+D into sum2

	ldr	r0,	=sum1		@ Load address of sum1
	ldr	r1,	[r0]		@ Load value of sum1 into r1
	ldr	r2,	=sum2		@ Load address of sum2
	ldr	r3,	[r2]		@ Load value of sum2 into r3

	sub	r1,	r3		@ sum1 = sum1 + sum2

	ldr	r2,	=sum3		@ Load sum3 address
	str	r1,	[r2]		@ Store sum into [r2] (sum3)

	@ Stage 4 of Program - Displaying Calculation and addresses

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print newline

	ldr	r0,	=charPb		@ Load "("
	bl	putstring		@ Print "("

	ldr	r1,	=intA		@ Load address of intA
	ldr	r0,	[r1]		@ Load value of intA into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print intA

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	ldr	r0,	=charPlus	@ Load "+"
	bl	putstring		@ Print "+"
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "

	ldr	r1,	=intB		@ Load address of intB
	ldr	r0,	[r1]		@ Load value of intB into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print intB

	ldr	r0,	=charPe		@ Load ")"
	bl	putstring		@ Print ")"

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	ldr	r0,	=charMinus	@ Load "-"
	bl	putstring		@ Print "-"
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "

	ldr	r0,	=charPb		@ Load "("
	bl	putstring		@ Print "("

	ldr	r1,	=intC		@ Load address of intC
	ldr	r0,	[r1]		@ Load value of intC into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print intC

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	ldr	r0,	=charPlus	@ Load "+"
	bl	putstring		@ Print "+"
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "

	ldr	r1,	=intD		@ Load address of intD
	ldr	r0,	[r1]		@ Load value of intD into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print intD

	ldr	r0,	=charPe		@ Load ")"
	bl	putstring		@ Print ")"
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	ldr	r0,	=charEquals	@ Load "="
	bl	putstring		@ Print "="
	bl	putstring		@ Print "="
	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "

	ldr	r1,	=sum3		@ Load address of sum3
	ldr	r0,	[r1]		@ Load value of sum3 into r1
	ldr	r1,	=numBuffer	@ Load buffer
	bl	intasc32		@ Convert int to ascii
	mov	r0,	r1		@ Load value of r1 into r0
	bl	putstring		@ Print sum3

	@ Stage 5 of Program - Displaying the Addresses

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print newline
	bl	putch			@ Print newline

	ldr	r0,	=addressOutput	@ Load "The addresses of the 4 ints:"
	bl	putstring		@ Print "The addresses of the 4 ints:"

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print newline

	ldr	r0,	=addressPrefix	@ Load "0x"
	bl	putstring		@ Print "0x"

	ldr	r0,	=intA		@ Load address of intA
	ldr	r1,	=addressBuffer	@ Load the buffer to hold address
	mov	r2,	#0x8		@ Load value of 8 for address of 8 length
	bl	hexToChar		@ Convert the address into ascii
	mov	r0,	r1		@ Move the converted value into r0
	bl	putstring

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	bl	putstring		@ Print " "
	bl	putstring		@ Print " "

	ldr	r0,	=addressPrefix	@ Load "0x"
	bl	putstring		@ Print "0x"

	ldr	r0,	=intB		@ Load address of intB
	ldr	r1,	=addressBuffer	@ Load the buffer to hold address
	mov	r2,	#0x8		@ Load value of 8 for address of 8 length
	bl	hexToChar		@ Convert the address into ascii
	mov	r0,	r1		@ Move the converted value into r0
	bl	putstring

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	bl	putstring		@ Print " "
	bl	putstring		@ Print " "

	ldr	r0,	=addressPrefix	@ Load "0x"
	bl	putstring		@ Print "0x"

	ldr	r0,	=intC		@ Load address of intC
	ldr	r1,	=addressBuffer	@ Load the buffer to hold address
	mov	r2,	#0x8		@ Load value of 8 for address of 8 length
	bl	hexToChar		@ Convert the address into ascii
	mov	r0,	r1		@ Move the converted value into r0
	bl	putstring

	ldr	r0,	=space		@ Load " "
	bl	putstring		@ Print " "
	bl	putstring		@ Print " "
	bl	putstring		@ Print " "

	ldr	r0,	=addressPrefix	@ Load "0x"
	bl	putstring		@ Print "0x"

	ldr	r0,	=intD		@ Load address of intD
	ldr	r1,	=addressBuffer	@ Load the buffer to hold address
	mov	r2,	#0x8		@ Load value of 8 for address of 8 length
	bl	hexToChar		@ Convert the address into ascii
	mov	r0,	r1		@ Move the converted value into r0
	bl	putstring

	ldr	r0,	=n		@ Load newline
	bl	putch			@ Print newline
	bl	putch			@ Print newline

	mov 	r0,	#0		@ Exit Code
	mov	r7,	#1		@ Service Code
	svc	0			@ Termination Permission
	.end
