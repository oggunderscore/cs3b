@ Note: 

@ r3 = array address
@ r4 = index of array
@ r5 = Comparison value for index

.data
arr:		.word 	0,0,0,0,0,0,0,0,0,0	@ 10 int array
buffer: 	.space 	6			@ Input buffer
n:		.byte	10			@ New line buffer
input:		.asciz 	"Input 10 ints: "	@ Text String
output:		.asciz 	"Output: "		@ Text String
sumText:	.asciz 	"Sum: "			@ Text String
numBuffer:	.asciz	"000000000000"		@ Number buffer
index:		.word	0			@ Index for arr
space:		.asciz	" "			@ Space text
printText:	.asciz	"Printing..."		@ Printing text

.text

	.global _start

incrementIndex:		@ !! Uses r4, r5

	ldr	r4, =index	@ Load address of index
	ldr	r5, [r4]	@ Load value
	add	r5, #0x4	@ Increment index
	str	r5, [r4]	@ Store into index

	bx	lr

compareIndex:		@ !! Uses r4, r5

	mov	r5, #0x24	@ Load value 40 for index 9
	ldr	r4, =index	@ Load address of current index
	ldr	r4, [r4]	@ Load value
	cmp	r4, r5		@ Compare the index

	bx	lr

loopStore:

	ldr	r4, =index	@ Load index address
	ldr	r4, [r4]	@ Load value

	ldr 	r0, =buffer	@ Load the address of the buffer
	mov	r1, #0x6	@ Load buffer size of 6 bytes
	bl	getstring	@ Load input for getstring
	bl	ascint32	@ Convert from ascii to int
	ldr	r1, =arr	@ Load address of x into r1
	str	r0, [r1, r4]	@ Store converted ascii from r0 into address of r1[r4]

	bl	compareIndex	@ Compare
	bl	incrementIndex	@ Increment

	beq	prePrint	@ Exit this loop if index == 9
	b	loopStore	@ Else reiterate

prePrint:

	ldr 	r0, =printText	@ Load print
	bl	putstring	@ Print Str

	ldr	r0, =n		@ Load newline
	bl	putch		@ Print newline

	ldr	r5, =index	@ Load index
	mov	r4, #0x0	@ Reset index if == 9
	str	r4, [r5]	@ Store code 0

	b	loopPrint	@ Go to loopPrint function
	

loopPrint:

	ldr	r4, =index	@ Load index address
	ldr	r4, [r4]	@ Load value of index (should be 0)

	ldr	r0, =arr	@ Load address of arr
	ldr	r0, [r0, r4]	@ Dereference & Load the value of current index
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	ldr 	r0, =space	@ Load space
	bl	putstring	@ Print Str

	bl	compareIndex	@ Compare
	bl	incrementIndex	@ Increment

	beq	preSum		@ Exit this loop if index == 9
	b	loopPrint	@ Else reiterate

preSum:	

	ldr	r0, =n		@ Load newline
	bl	putch		@ Print newline

	ldr 	r0, =sumText	@ Load print
	bl	putstring	@ Print Str

	ldr	r0, =n		@ Load newline
	bl	putch		@ Print newline

	ldr	r5, =index	@ Load index
	mov	r4, #0x0	@ Reset index if == 9
	str	r4, [r5]	@ Store code 0

	mov	r1, #0x0	@ Reset r1 to 0 to be counted as sum

	b	loopSum		@ Enter the summer

printSum:

	mov	r0, r1		@ Move the sum from r1 to r0
	ldr	r1, =numBuffer	@ Load conversion buffer
	bl	intasc32	@ Convert to ascii
	mov	r0, r1		@ Move the finished result into r0
	bl	putstring	@ Print

	b	exit		@ Exit program

loopSum:

	ldr	r4, =index	@ Load index address
	ldr	r4, [r4]	@ Load value of index (should be 0)

	ldr	r0, =arr	@ Load address of arr
	ldr	r0, [r0, r4]	@ Dereference & Load the value of current index

	add	r1, r0		@ r1 (sum) = r1 + arr[x];


	bl	compareIndex	@ Compare
	bl	incrementIndex	@ Increment

	bleq	printSum	@ Print the value of r0 if index == 9x
	b	loopSum		@ Else reiterate

exit:

	ldr	r0, =n		@ Load newline
	bl	putch		@ Print newline

	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission

_start:
	ldr 	r0, =input	@ Load string enter input
	bl	putstring	@ Print Str

	b	loopStore

	.end
