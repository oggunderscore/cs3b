	.data

mult:	.word	1			@ Multiplier

.text

idivStart:

	cpy	r4,	r0		@ Copy Numerator to r4
	cpy	r5,	r1		@ Copy Denominator to r5

	b	idivZero		@ Call to check if deno is zero

idivZero:

	cmp	r1,	#0x0		@ Compare denominator to 0
	beq	idivExit		@ If zero, then exit this division function
	b	idivNegatives		@ Else, then proceed to check negatives of num & denom

changeMult:

	ldr	r3,	=mult		@ Load address of multiplier
	ldr	r4,	[r3]		@ Load value of mult
	mul	r4,	r2		@ Multiply Mult by -1
	str	r4,	[r3]		@ Store the final value back into mult

	bx	lr			@ Return call


idivNegatives:				@ Checks if num or denom is neg, if so, mult * -1

	@ r0 = Num	r1 = Denom	r2 = -1		r3 = Address of Mult	 r4 = Value of Mult
	mov	r2,	#0xFFFFFFFF	@ -1 value

	@ Checking if the numerator is neg
	cmp	r0,	#0x0		@ Check num < 0
	mullt	r0,	r2		@ If num < 0, num * -1
	bllt	changeMult		@ Do mult * -1

	@ Checking if the denominator is neg
	cmp	r1,	#0x0		@ Check num < 0
	mullt	r1,	r2		@ If num < 0, num * -1
	bllt	changeMult		@ Do mult * -1

	b	divideLoopStart		@ Branch to next step

divideLoopStart:

	mov	r2,	#0xFFFFFFFF	@ -1 value
	mov	r3,	#0x0		@ Reset r2-r3
	mov	r4,	#0x0		@ Reset r2-r3

	b	divideLoop		@ Start looping

divideLoop:

	@ r0 = Num	r1 = Denom	r2 = -1		r3 = Resulting dividend		r4 = Remainder

	sub	r0,	r1		@ N = N - D
	cmp	r0,	#0x0		@ Compare!

	addge	r3,	#0x1		@ Add 1 to D
	bge	divideLoop		@ loop back since it isnt negative yet
	addlt	r0,	r1		@ If negative result, reverse the negation
	movlt	r4,	r0		@ Move the resulted num into remainder
	blt	idivExit		@ Finish loop


idiv:					@ Main call
	push 	{r4-r8, r10,r11}
    	push	{lr}
	b	idivStart		@ Call starting

idivExit:

	ldr	r2,	=mult		@ Load multiplier
	ldr	r2,	[r2]		@ Load the value
	mul	r3,	r2		@ Multiply by the result

	mov	r0,	r3		@ Reload result back
	mov	r1,	r4		@ Reload result back

	pop	{lr}			@ Pop registers
	pop	{r4-r8, r10,r11}	@ Pop registers
	bx	lr			@ return to call
