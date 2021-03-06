.data
szX:	.asciz "10"
szY:	.asciz "15"
iX:	.word 0
iY:	.word 0
iSum:	.word 0
x:	.word 0
y:	.word 0
xySum:	.word 0
buffer: .space 6
enterX:	.asciz "Input x: "
enterY: .asciz "Input y: "
ampX:	.asciz "&x = 0x"
ampY:	.asciz "&y = 0x"
tWord:	.asciz "00000000"
n:	.byte 10

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

	ldr 	r0, =enterX	@ Load string enterX
	bl	putstring	@ Print Str

	ldr 	r0, =buffer	@ Load the address of the buffer
	mov	r1, #0x6	@ Load buffer size of 6 bytes
	bl	getstring	@ Load input for getstring
	bl	ascint32	@ Convert from ascii to int
	ldr	r1, =x		@ Load address of x into r1
	str	r0, [r1]	@ Store converted ascii from r1 into address of r0

	ldr	r0, =enterY
	bl	putstring

	ldr	r0, =buffer	@ Repeat for variable y
	mov	r1, #0x6
	bl	getstring
	bl	ascint32
	ldr	r1, =y
	str	r0, [r1]

	ldr 	r0, =ampX	@ Load &x string
	bl	putstring	@ Print &x

	ldr	r0, =x		@ Load x address for printing
	ldr	r1, =tWord	@ R1: Load string to hold converted hex to ascii
	mov 	r2, #0x8	@ R2: Load 8 nibbles???
	bl	hexToChar	@ Convert hex to asciz?? or ascii?
	mov	r0, r1		@ Move the converted string that is stored in r1's address into r0
	bl	putstring	@ Print address of x through the address located in r0

	ldr 	r0, =n		@ Load new line
	bl	putch		@ Print new line

	ldr	r0, =ampY
	bl	putstring

	ldr	r0, =y
	ldr	r1, =tWord
	mov	r2, #0x8
	bl	hexToChar
	mov	r0, r1
	bl	putstring

	ldr	r0, =n
	bl	putch

	ldr	r0, =x		@ Load x address
	ldr	r1, [r0]	@ Load value of r0
	ldr	r2, =y		@ Load y address
	ldr	r3, [r2]	@ Load value of r2

	add 	r1, r3		@ x = x + y; Adding logic
	ldr	r4, =xySum	@ Load address of xySum to r4
	str	r1, [r4]	@ Store value from r1 into address of r4

	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission
	.end
