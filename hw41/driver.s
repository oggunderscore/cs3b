@ Purpose: Stack Problem
@          Provided by Professor B.

        .data

        .text

        .global _start          @ Provide program starting address to linker

_start:
		mov     r0, #3
           mov     r4, #4
           mov     r5, #5
           mov     r6, #6
           mov     r7, #7
           mov     r8, #8
           mov     r10, #10
           mov     r11, #11

           bl      _div2

           mov     r0, #0          @ Set program Exit Status code to 0.
           mov     r7, #1          @ Service command code of 1 to terminate pgm.

           svc     0               @ Perform Service Call to Linux.
        .end
