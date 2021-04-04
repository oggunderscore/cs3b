    .data
    
    
        .text
        
    .global     _start      @ Starting Point
    
_start:

    mov     r0, #-2
    push    {r0}
    mov     r1, #3
    
    bl      fact
    
    pop     {r0}
    
    mov     r0, #0
    mov     r7, #1
    svc     0
    
.end
