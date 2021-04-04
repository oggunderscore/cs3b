@ NOTE: In this program, I use a few 
@ registers to hold crucial information.

@ r3 holds the exit code. Where the input 
@ is invalid, it will turn r3 into 999 (dec) / 3E7 (hex)

@ r4 holds the comparison exit code
@ Which is compared to r3 at the end of the loop

@ Should r3 == r4, the program will exit	


	.data
x:		.word 	0		@ Variable
buffer: 	.space 	6		@ Input buffer
n:		.byte	10		@ New line buffer
input:		.asciz 	"Input: "	@ Text String
output:		.asciz 	"Output: "	@ Text String
high:		.asciz 	"Too High!"	@ Text String
low:		.asciz 	"Too Low!"	@ Text String
a:		.asciz	"A"		@ Grade symbol
b:		.asciz	"B"		@ Grade symbol
c:		.asciz	"C"		@ Grade symbol
d:		.asciz	"D"		@ Grade symbol
f:		.asciz	"F"		@ Grade symbol

	.text

	.global _start

function:
	@ Stage 1 - Getting input
	
	mov	r4, #0x3E7	@ Load reference error point in r4
	ldr 	r0, =input	@ Load string enterX
	bl	putstring	@ Print Str

	ldr 	r0, =buffer	@ Load the address of the buffer
	mov	r1, #0x6	@ Load buffer size of 6 bytes
	bl	getstring	@ Load input for getstring
	bl	ascint32	@ Convert from ascii to int
	ldr	r1, =x		@ Load address of x into r1
	str	r0, [r1]	@ Store converted ascii from r1 into address of r0

	@ Stage 3 - Comparing the symbols

	ldr	r1, =x		@ Load address of num1
	ldr	r1, [r1]	@ Load the value of num1 into r1


	mov	r2, #0x64	@ Load value 100 into r2
	cmp	r1, r2		@ Compare the two
	ldrgt	r0, =high	@ Load result invalid input if > 100
	movgt	r3, #0x3E7	@ Load 999 into r3 if invalid input
	ldrle	r0, =a		@ Load result A if input is <= 100

	mov	r2, #0x5A	@ Load value 90 into r2
	cmp	r1, r2		@ Compare the two
	ldrlt	r0, =b		@ Load result B if input is < 90

	mov	r2, #0x50	@ Load value 80 into r2
	cmp	r1, r2		@ Compare the two
	ldrlt	r0, =c		@ Load result C if input is < 80

	mov	r2, #0x46	@ Load value 70 into r2
	cmp	r1, r2		@ Compare the two
	ldrlt	r0, =d		@ Load result D if input is < 70

	mov	r2, #0x3C	@ Load value 60 into r2
	cmp	r1, r2		@ Compare the two
	ldrlt	r0, =f		@ Load result F if input is < 60

	mov	r2, #0x00	@ Load value 0 into r2
	cmp	r1, r2		@ Compare the two
	ldrlt	r0, =low	@ Load result Invalid input if input is < 0
	movlt	r3, #0x3E7	@ Load 999 into r3 if invalid input

	@ Stage 4 - Printing

	mov	r1, r0		@ Move the resulted grade to r1 temporarily
	ldr	r0, =output	@ Load output line
	bl	putstring	@ Print

	mov	r0, r1		@ Move result back
	bl	putstring	@ Print result grade

	@ Stage 5 - Cleanup

	ldr	r0, =n		@ Load newline
	bl	putch		@ Print newline
	bl	putch		@ Print newline

	cmp	r3, r4		@ Compare the error flag before clearing
	mov	r3, #0x00	@ Clean up conditional flag
	beq	exit		@ If code = 999, then exit program
	b	function	@ Else loop back

exit:
	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission

_start:
	b	function	@ Execute function

	.end


	

