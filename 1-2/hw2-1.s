.data
var1:	.word  23
var2:	.long  0xC
expr:	.ascii ">>"

.text

	.global main	@ Provide program starting address to linker

main: 
	ldr r0, =var1	@ load into r0 the address of var1
	ldr r1, =var2	@ load into r1 the address of var2
	ldr r2, =expr	@ load into r2 the address of expr

	mov r0, #0	@ Exit status code is 0 for normal completion
	mov r7, #1	@ Service command code
	svc 0		@ Issue linux command to terminate program
	.end
