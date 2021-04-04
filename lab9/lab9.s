.equ	SIZE, 64
	.data

iSrcArray:	.word	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iDestArray:	.skip	SIZE

iY:		.word	0
iSum:		.word 	0

	.text

	.global	_start

_start:

	ldr	r0, =iSrcArray
	ldr	r1, =iDestArray

	ldm	r0!, {r2-r5}
	stm	r1!, {r2-r5}

	ldm	r0!, {r2-r5}
	stm	r1!, {r2-r5}

	mov	r0, #0		@ Exit code
	mov	r7, #1		@ Service code
	svc	0
	.end
