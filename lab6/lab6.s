.data
szMsg1:	.asciz "The sun did not shine."
szMsg2: .asciz "It was too wet to play."
cCr:	.byte 10

.text

	.global _start

_start:

	ldr r0, =szMsg1
	bl	putstring

	ldr r0, =cCr
	bl	putch

	ldr r0, =szMsg2
	bl	putstring

	ldr r0, =cCr
	bl	putch

	mov r0, #0
	mov r7, #1
	svc 0
	.end
