	.global _start @ Provide program starting address to Linker

_start: 
	mov r0, #7	@ Exit Status code set to 7 if completed
	mov r7, #1	@ Service command 1 will terminate program
	svc 0		@ Issue Linux command to terminate program

	.end
