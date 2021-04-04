.equ	size, 13					@ Size formatting for buffer

	.data							@ Data directive for variables and constants
straName:	.asciz	"Name: "				@ Text String
straClass:	.asciz	"Class: "				@ Text String
straLab:	.asciz	"Lab: "					@ Text String
straDate:	.asciz	"Date: "				@ Text String
strname:	.asciz	"Kevin Nguyen"				@ Text String
strclass:	.asciz	"CS 3B"					@ Text String
strlab:		.asciz	"RASM2"					@ Text String
strdate:	.asciz	"10/11/2020"				@ Text String
intX:		.word	0					@ Input X
intY:		.word	0					@ Input Y
strimpNum1:	.asciz	"Enter your first number: "		@ Input Text X
strimpNum2:	.asciz	"Enter your second number: "		@ Input Text Y
n:		.byte	10					@ Newline
impBuffer:	.skip	size					@ Input buffer
numBuffer:	.asciz	"000000000000000"			@ Number buffer
isum:		.word	0					@ Actual sum
idifference:	.word	0					@ Actual difference
iproduct:	.word	0					@ Actual product
iquotient:	.word	0					@ Actual quotient
iremainder:	.word	0					@ Actual remainder
strsumOut:	.asciz	"The sum is "				@ Output text
strdifferenceOut:.asciz	"The difference is "			@ Output text
strproductOut:	.asciz	"The product is "			@ Output text
strquotientOut:	.asciz	"The quotient is "			@ Output text
strremainderOut:.asciz	"The remainder is "			@ Output text
strerrorDenom:	.asciz	"You cannot divide by 0! "		@ Output text
strendProgram:	.asciz	"Thanks for using my program! Goodbye!\n"	@ Output text
stroverflowAdd:	.asciz	"ERROR: OVERFLOW WHILE ADDING!"		@ Output text
stroverflowMul:	.asciz	"ERROR: OVERFLOW WHILE MULTIPLYING!"	@ Output text
strinvalidStr:	.asciz	"ERROR: INVALID INPUT. RE-ENTER VALUE.\n"	@ Output text
strinputOverflow:	.asciz	"ERROR: INPUT OVERFLOW. RE-ENTER VALUE.\n"	@ Output text


.text

	.global _start

printHeader:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	@ Stage 1 of Program - Print Header

	ldr	r0,	=straName		@ Load "Name: "
	bl	putstring			@ Print r0
	ldr	r0,	=strname		@ Load var name
	bl	putstring			@ Print r0

	bl	nL				@ Print newline

	ldr	r0,	=straClass		@ Load "Class: "
	bl	putstring			@ Print r0
	ldr	r0,	=strclass		@ Load var class
	bl	putstring			@ Print r0

	bl	nL				@ Print newline

	ldr	r0,	=straLab		@ Load "Lab: "
	bl	putstring			@ Print r0
	ldr	r0,	=strlab			@ Load var lab
	bl	putstring			@ Print r0

	bl	nL				@ Print newline

	ldr	r0,	=straDate		@ Load "Date: "
	bl	putstring			@ Print r0
	ldr	r0,	=strdate		@ Load var date
	bl	putstring			@ Print r0

	bl	nL				@ Print newline

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call

calcSum:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register
	bl	loadInput			@ Load X and Y

	adds	r0,	r1			@ Add r0 r1

	bvs	errorOverflowAdd		@ Result to overflow if overflowed

	ldr	r1,	=isum			@ Load address of sum
	str	r0,	[r1]			@ Store into address of sum

	bl	printSum			@ Print sum

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

errorOverflowAdd:

	ldr	r0,	=stroverflowAdd		@ Load str
	bl	putstring			@ Print

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return

printSum:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	bl	nL				@ Print newline

	ldr	r0,	=strsumOut		@ Load String
	bl	putstring			@ Print it

	ldr	r1,	=isum			@ Load address of int
	ldr	r0,	[r1]			@ Load value of int into r1
	ldr	r1,	=numBuffer		@ Load buffer
	bl	intasc32			@ Convert int to ascii
	mov	r0,	r1			@ Load value of r1 into r0
	bl	putstring			@ Print int

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

calcDifference:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register
	bl	loadInput			@ Load X and Y

	sub	r0,	r1			@ Sub r0 - r1
	
	ldr	r1,	=idifference		@ Load address of difference
	str	r0,	[r1]			@ Store into address of difference

	bl	printDifference			@ Print difference

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

printDifference:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	bl	nL				@ Print newline

	ldr	r0,	=strdifferenceOut	@ Load String
	bl	putstring			@ Print it

	ldr	r1,	=idifference		@ Load address of int
	ldr	r0,	[r1]			@ Load value of int into r1
	ldr	r1,	=numBuffer		@ Load buffer
	bl	intasc32			@ Convert int to ascii
	mov	r0,	r1			@ Load value of r1 into r0
	bl	putstring			@ Print int

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

calcProduct:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register
	bl	loadInput			@ Load X and Y

	smull 	r0, ip, r1, r0			@ Multiply r0 times r1
	cmp 	ip, r0, ASR #31 			

	bne	errorOverflowMult		@ Error for overflow

	ldr	r1,	=iproduct		@ Load address of product
	str	r0,	[r1]			@ Store into address of product

	bl	printProduct			@ Print product

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

errorOverflowMult:

	bl	nL				@ Print newline

	ldr	r0,	=stroverflowMul		@ Load str
	bl	putstring

	bl	nL				@ Print newline

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return

printProduct:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	bl	nL				@ Print newline

	ldr	r0,	=strproductOut		@ Load String
	bl	putstring			@ Print it

	ldr	r1,	=iproduct		@ Load address of int
	ldr	r0,	[r1]			@ Load value of int into r1
	ldr	r1,	=numBuffer		@ Load buffer
	bl	intasc32			@ Convert int to ascii
	mov	r0,	r1			@ Load value of r1 into r0
	bl	putstring			@ Print int

	bl	nL				@ Print newline

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

calcDivide:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register
	bl	loadInput			@ Load X and Y

	cmp	r1,	#0x0			@ Compare denominator to 0

	blne	idiv				@ Divide

	beq	errorDenomZero			@ Exit here and execute error code

	bl	printDivide			@ Print results

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

printDivide:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	ldr	r2,	=iquotient		@ Load quotient
	str	r0,	[r2]			@ Store into quotient
	ldr	r3,	=iremainder		@ Load quotient
	str	r1,	[r3]			@ Store into quotient

	ldr	r0,	=strquotientOut		@ Load String
	bl	putstring			@ Print it

	ldr	r1,	=iquotient		@ Load address of int
	ldr	r0,	[r1]			@ Load value of int into r1
	ldr	r1,	=numBuffer		@ Load buffer
	bl	intasc32			@ Convert int to ascii
	mov	r0,	r1			@ Load value of r1 into r0
	bl	putstring			@ Print int

	bl	nL				@ Print newline

	ldr	r0,	=strremainderOut	@ Load String
	bl	putstring			@ Print it

	ldr	r1,	=iremainder		@ Load address of int
	ldr	r0,	[r1]			@ Load value of int into r1
	ldr	r1,	=numBuffer		@ Load buffer
	bl	intasc32			@ Convert int to ascii
	mov	r0,	r1			@ Load value of r1 into r0
	bl	putstring			@ Print int

	bl	nL				@ Print newline

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location


errorDenomZero:

	ldr	r0,	=strerrorDenom		@ Load Error string
	bl	putstring			@ Print

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

checkNullInput:

	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	ldr	r0,	=impBuffer		@ Load input buffer
	ldrb	r0,	[r0]			@ Load the first byte
	cmp	r0,	#0x0			@ Compare to 0
	beq	terminate			@ Exit program

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return to call location

resetInputBuffer:



getX:

	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	mov	r2,	#0x0			@ Reset error flag

	ldr	r0,	=strimpNum1		@ Load string
	bl	putstring			@ Print r0

	ldr	r0,	=impBuffer		@ Load the input buffer address
	mov	r1,	#size			@ Load the size of the buffer
	bl	getstring			@ Load input into impBuffer
	bl	ascint32			@ Convert to int

	blcs	errorInvalid			@ Check for invalid
	blvs	errorInputOverflow		@ Check for input overflow

	cmp	r2,	#0x9			@ Check error flag
	beq	getX				@ Reiterate if error

	ldr	r1,	=intX			@ Load address of intA
	str	r0,	[r1]			@ Store converted value into deref r1

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return call

getY:

	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	mov	r2,	#0x0			@ Reset error flag

	ldr	r0,	=strimpNum2		@ Load string
	bl	putstring			@ Print r0

	ldr	r0,	=impBuffer		@ Load the input buffer address
	mov	r1,	#size			@ Load the size of the buffer
	bl	getstring			@ Load input into impBuffer
	bl	ascint32			@ Convert to int

	blcs	errorInvalid			@ Check for invalid
	blvs	errorInputOverflow		@ Check for input overflow

	cmp	r2,	#0x9			@ Check error flag
	beq	getY				@ Reiterate if error

	ldr	r1,	=intY			@ Load address of intA
	str	r0,	[r1]			@ Store converted value into deref r1

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return call


errorInvalid:

	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register


	ldr	r0,	=strinvalidStr		@ Load invalid string
	bl	putstring			@ Print

	mov	r2,	#0x9			@ Error flag

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return

errorInputOverflow:

	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	ldr	r0,	=strinputOverflow	@ Load overflow string
	bl	putstring			@ Print

	mov	r2,	#0x9			@ Error flag

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return

getInput:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register
	bl	loadInput			@ Load X and Y

	@ Stage 2 of program - Gather Input

	@ Var X

	bl	nL				@ Print newline
	bl	nL				@ Print newline

	bl	getX				@ Get input for X

	bl	checkNullInput			@ Check for null input

	@ Var Y

	bl	getY				@ Get input for Y

	bl	checkNullInput			@ Check for null input

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return call

nL:
	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	ldr	r0,	=n			@ Load newline
	bl	putch				@ Print newline

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Back to call

loadInput:

	ldr	r0,	=intX			@ Load address of intX
	ldr	r0,	[r0]			@ Dereference value
	ldr	r1,	=intY			@ Load address of intY
	ldr	r1,	[r1]			@ Dereference value

	bx	lr				@ Return call

terminate:

	bl	nL				@ Print newline	

	ldr	r0,	=strendProgram		@ Load ending string
	bl	putstring			@ Print

	mov 	r0,	#0			@ Exit Code
	mov	r7,	#1			@ Service Code
	svc	0				@ Termination Permission

mainProgram:

	push 	{r4-r8, r10,r11}		@ Push preserved registers
	push	{lr}				@ Push link register

	bl	getInput			@ Call getInput

	bl	calcSum				@ Call calcSum
	bl	calcDifference			@ Call calcDifference
	bl	calcProduct			@ Call calcProduct
	bl	calcDivide			@ Call calcDivide

	b	mainProgram			@ Recursive until terminate called by getInput

	pop	{lr}				@ Pop link register
	pop 	{r4-r8, r10,r11}		@ Pop preserved registers
	bx	lr				@ Return call

_start:

	bl	printHeader			@ Call printHeader

	bl	mainProgram			@ Call mainprogram

	b	terminate			@ Terminate program
	
	.end
