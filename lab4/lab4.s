.data
iX:	.word 3		@ Uses 2 bytes
iY:	.word 5		@ Uses 2 bytes
lZ:	.long 6		@ Uses 4 bytes
cChar:	.byte 'A'	@ Uses 1 bytes
.balign 4
iA:	.word 1		@ Uses 2 bytes
			@ Total Bytes used in data: 11 bytes
.text

	.global _start	@ Provide program starting address to linker

_start: 
	ldr r0, =iX	@ load into r0 the address of iX
	ldr r0, [r0]	@ dereference r0 to get value
	ldr r1, =iY
	ldr r1, [r1]

	add r0, r1

	mov r0, #0	@ Exit status code is 0 for normal completion
	mov r7, #1	@ Service command code
	svc 0		@ Issue linux command to terminate program
	.end
