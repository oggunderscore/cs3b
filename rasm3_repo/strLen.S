// Subroutine strLen accepts the address of a string and counts the characters in the string, excluding the NULL character and returns that value as an int (word) in the R0 register. will read a string of characters terminated by a null
// strLen(string: *char)
//    R0: Points to first byte of string to count
//    LR: Contains the return address
// Returned register contents:
//    R0: Number of characters in the string (does not include null).
// All registers are preserved as per AAPCS
    .text
    .global strLen
strLen:
        // preserve AAPCS registers
        push {r4-r8, r10,r11}
        push {lr}
        mov r3, #0              // r3 = counter
_string_len_top:                // while char != NULL {
        ldrb r4, [r0, r3]       //  load byte from str ptr in r0 using r3 as register offset
        cmp r4, #0              //  check if byte is NULL
        beq _string_len_exit    //  if (char == NULL) {break}
        add r3, r3, #1          //  counter += 1
        b _string_len_top       // }


_string_len_exit:
        cpy r0, r3  // persist counter to r0 as return value
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr
    .end
