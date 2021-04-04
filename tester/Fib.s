@ Fib.s
@
@ Dynamic Programming implementation
@@@@@@@ INPUT: @@@@@@@@
@
@@ non-negative integer n in r0
@@ (no test: negative values address locations outside array)
@
@@@@@@@ OUTPUT: @@@@@@@@@@@
@
@@ nth Fibonacci number in r0
@
@@@@@@@ TO USE: @@@@@@@@@@@
@
@@ mov r0, n @ Put the n in r0
@@ bl Fib @ Returns with answer in r0
@

	.data
FibArray:
	.word 0 @ Fib(0) = 0
	.word 1 @ Fib(1) = 1
	.skip 192

	.global	Fib

	.text

Fib: @ <= entry point
@ save registers
	push {r4, r5, r6, lr} @ 8 byte aligned
	
@ check for zero
	cmp r0, #0
	beq return @ Fib(0) = 0
	
@ check FibArray for answer
	mov r4, r0 @ save n in r4
	mov r1, r0, LSL #2 @ take r0 = n and get r1 = 4*n
	ldr r0, =FibArray @ get array address
	add r0, r1, r0 @ actual location address
	mov r6, r0 @ save that location address in r6
	ldr r0, [r0] @ what's there
	cmp r0, #0 @ has it been calculated yet?
	bne return @ if not zero, found it already
	
@ otherwise we have to actually do the calculation
@ adjust input parameter
	sub r0, r4, #1 @ n-1 new argument
	bl Fib @ first recursive call
	mov r5, r0 @ save result in r5
	sub r0, r4, #2 @ now use n-2 as argument
	bl Fib @ second recursive call
	add r0, r5, r0 @ new result
	str r0, [r6] @ save it in FibArray at correct location

@ restore registers
return:
	pop {r4, r5, r6, lr}
	bx lr

