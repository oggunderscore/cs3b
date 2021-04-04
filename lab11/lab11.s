.data
iX:	.word 0xDEADBEEF
iY:	.word 0xCAFEBABE

.text

	.global _start

_start:

	ldr	r6, =iX		@ Load address of iX
	ldr	r6, [r6]	@ Dereference Value
	ldr	r7, =iY		@ Load address of iY
	ldr	r7, [r7]	@ Dereference Value

	add 	r0, r6, r7	@ add(s) (iX, iY)
	adc	r1, r6, r7	@ adc (iX, iY)
	subs	r2, r6, r7	@ sub(s) (iX, iY)
	sbc	r3, r6, r7	@ sbc (iX, iY)
	rsb	r4, r6, r7	@ rsb (iX, iY)
	rsc	r5, r6, r7	@ rsc (iX, iY)

	mov r0, #0	@ Exit Code
	mov r7, #1	@ Service Code
	svc 0		@ Termination Permission
	.end
