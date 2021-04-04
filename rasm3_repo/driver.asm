    .data
szBuffer:           .space  512       // string IO buffer
szLF:               .asciz "\n"      // Line feed.
szTrue:             .asciz "TRUE"
szFalse:            .asciz "FALSE"
szQuote:            .asciz "\""
szSingleQuote:      .asciz "'"

szS1:               .asciz      "Cat in the hat."
szS2:               .asciz      "fog"
szS3:               .asciz      "cat in the hat."
sz1_prompt_a:       .asciz      "1. s1.length() = "
sz1_prompt_b:       .asciz      "   s2.length() = "
sz1_prompt_c:       .asciz      "   s3.length() = "
sz2_prompt:         .asciz      "2. String_equals(s1,s3) = "
sz3_prompt:         .asciz      "3. String_equals(s1,s1) = "
sz4_prompt:         .asciz      "4. String_equalsIgnoreCase(s1,s3) = "
sz5_prompt:         .asciz      "5. String_equalsIgnoreCase(s1,s2) = "
sz6_prompt_a:       .asciz      "6. s4 = String_copy(s1)"
sz6_prompt_b:       .asciz      "   s1 = "
sz6_prompt_c:       .asciz      "   s4 = "
sz7_prompt:         .asciz      "7. String_substring_1(s3,4,14) = \""
sz8_prompt:         .asciz      "8. String_substring_2(s3,7) = \""
sz9_prompt:         .asciz      "9. String_charAt(s2,4) = '"
sz10_prompt:        .asciz      "10. String_startsWith_1(s1,11,\"hat.\") = "
sz11_prompt:        .asciz      "11. String_startsWith_2(s1,\"Cat\") = "
sz12_prompt:        .asciz      "12. String_endsWith(s1,\"in the hat.\") = "
sz13_prompt:        .asciz      "13. String_indexOf_1(s2,'g') = "
sz14_prompt:        .asciz      "14. String_indexOf_2(s2,'g',9) = "
sz15_prompt:        .asciz      "15. String_indexOf_3(s2,\"fo\") = "
sz16_prompt:        .asciz      "16. String_lastIndexOf_1(s2,'g') = "
sz17_prompt:        .asciz      "17. String_lastIndexOf_2(s2,'g',6) = "
sz18_prompt:        .asciz      "18. String_lastIndexOf_3(s2,\"egg\") = "
sz19_prompt:        .asciz      "19. String_replace(s1,'a','o') = \""
sz20_prompt:        .asciz      "20. String_toLowerCase(s1) = \""
sz21_prompt:        .asciz      "21. String_toUpperCase(s1) = \""
sz22_prompt_a:      .asciz      "22. String_concat(s1, \" \");\n"
sz22_prompt_b:      .asciz      "    String_concat(s1,s2)      = \""

sz10:               .asciz      "hat."
sz11:               .asciz      "Cat"
sz12:               .asciz      "in the hat."
b13:                .byte       'g'
sz15:               .asciz      "g"
sz18:               .asciz      "egg"
sz22:               .asciz      " "
	.text

	.global main
	.global program_exit
// libc has its own _entry point, and will call our entry-point symbol `main`
main:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
stage1:
    /* * compute lengths in reverse order as stack is FIFO * */
    // strLen(string: *char)
    ldr r0, =szS3
    bl strLen
    push {r0}
    ldr r0, =szS2
    bl strLen
    push {r0}
    ldr r0, =szS1
    bl strLen
    push {r0}
    /* * render in forward sequence * */
    ldr r1, =szBuffer

    ldr r0, =sz1_prompt_a
    bl putstring                // libbarnet::putstring(sz1_prompt_a)
    pop {r0}                    // retrieve strLen(szS1) from stack
    // emitNumber(value: word, buffer: *char)
    bl emitNumber               // emitNumber(strLen(szS1))
    bl emitNewline              // emitNewline()

    ldr r0, =sz1_prompt_b
    bl putstring                // libbarnet::putstring(sz1_prompt_b)
    pop {r0}                    // retrieve strLen(szS1) from stack
    // emitNumber(value: word, buffer: *char)
    bl emitNumber               // emitNumber(strLen(szS1))
    bl emitNewline              // emitNewline()

    ldr r0, =sz1_prompt_c
    bl putstring                // libbarnet::putstring(sz1_prompt_c)
    pop {r0}                    // retrieve strLen(szS1) from stack
    // emitNumber(value: word, buffer: *char)
    bl emitNumber               // emitNumber(strLen(szS1))
    bl emitNewline              // emitNewline()

stage2:
    ldr r0, =sz2_prompt         // load prompt
    bl putstring                // libbarnet::putstring(sz2_prompt)
    // String_equals(a: *char, b: *char)
    // 2. String_equals(s1,s3) =
    ldr r0, =szS1
    ldr r1, =szS3
    bl String_equals            // String_equals(szS1, szS2)
    bl emitBool                 // emitBool(String_equals(szS1, szS2))
    bl emitNewline              // emitNewline()

stage3:
    /* 3. String_equals(s1,s1) = */
    ldr r0, =sz3_prompt         // load prompt
    bl putstring                // libbarnet::putstring(sz2_prompt)
    // String_equals(a: *char, b: *char)
    ldr r0, =szS1
    ldr r1, =szS1
    bl String_equals            // String_equals(szS1, szS2)
    bl emitBool                 // emitBool(String_equals(szS1, szS2))
    bl emitNewline              // emitNewline()

stage4:
    /* 4. String_equalsIgnoreCase(s1,s3) = */
    ldr r0, =sz4_prompt         // load prompt
    bl putstring                // libbarnet::putstring(sz2_prompt)
    // String_equals(a: *char, b: *char)
    ldr r0, =szS1
    ldr r1, =szS3
    bl String_equalsIgnoreCase  // String_equalsIgnoreCase(szS1, szS2)
    bl emitBool                 // emitBool(String_equalsIgnoreCase(szS1, szS2))
    bl emitNewline              // emitNewline()
stage5:
    /* "5. String_equalsIgnoreCase(s1,s2) = " */
    ldr r0, =sz5_prompt         // load prompt
    bl putstring                // libbarnet::putstring(sz2_prompt)
    // String_equals(a: *char, b: *char)
    ldr r0, =szS1
    ldr r1, =szS2
    bl String_equalsIgnoreCase  // String_equalsIgnoreCase(szS1, szS2)
    bl emitBool                 // emitBool(String_equalsIgnoreCase(szS1, szS2))
    bl emitNewline              // emitNewline()

stage6:
    /* 6. s4 = String_copy(s1) */
    ldr r0, =sz6_prompt_a       // load stage 6 prompt A
    bl putstring                // libbarnet::putstring(sz6_prompt_a)
    bl emitNewline              // emitNewline()

    ldr r0, =sz6_prompt_b       // load stage 6 prompt B
    bl putstring                // libbarnet::putstring(sz6_prompt_b)

    /// String_copy(origin: *char) -> *char
    ldr r0, =szS1               // load S1 for copy
    bl String_copy              // String_copy(szS1)
    push {r0}                   // keep track of dynamic memory.
    // emit S1 to prove its unchanged.
    ldr r0, =szS1               // reload S1
    bl putstring                // libbarnett::putstring(szS1)
    bl emitNewline              // emitNewline()
    // emit S2 to prove the copy worked.
    ldr r0, =sz6_prompt_c       // load stage 6 prompt C
    bl putstring                // libbarnet::putstring(sz6_prompt_c)
    pop {r4}                    // pop dynamic memory ptr from heap
    cpy r0, r4                  // load r0 with ptr to that memory for printing
    bl putstring                // libbarnet::putstring(s4)
    // cleanup.
    cpy r0, r4                  // copy it in again for free
    bl free                     // libc::free(s4)
    mov r0, #0                  // SAFETY: prevent use-after-free.
    mov r4, #0                  // SAFETY: prevent use-after-free.
    bl emitNewline              // emitNewline()

stage7:
    /* String_substring_1(s3,4,14) = */
    ldr r0, =sz7_prompt         // load prompt
    bl putstring                // libbarnet::putstring(sz7_prompt)

    ldr r0, =szS3               // load string 3
    mov r1, #4                  // load integer literal
    mov r2, #14                 // load integer literal
    bl String_substring_1       // substring = String_substring_1(szS3, 4,14)
    push {r0}                   // keep track of dynamic memory
    bl putstring                // libbarnet::putstring(substring)
    ldr r0, =szQuote            // load close quote
    bl putstring                // emit close quote
    bl emitNewline              // emit a newline
    pop {r0}                    // restore dynamic memory ptr
    bl free                     // libc::free(substring)
    mov r0, #0                  // SAFETY: prevent use-after-free

stage8:
    /* 8. String_substring_2(s3,7) = " */
    ldr r0, =sz8_prompt         // load prompt
    bl putstring                // libbarnet::putstring(sz8_prompt)

    ldr r0, =szS3               // load string 3
    mov r1, #7                  // load integer literal
    bl String_substring_2       // substring = String_substring_2(s3,7)
    push {r0}                   // keep track of dynamic memory
    bl putstring                // libbarnet::putstring(substring)
    ldr r0, =szQuote            // load close quote
    bl putstring                // libbarnet::putstring(szQuote)
    bl emitNewline              // emit a newline
    pop {r0}                    // restore dynamic memory ptr
    bl free                     // libc::free(substring)
    mov r0, #0                  // SAFETY: prevent use-after-free

stage9:
    /* 9. String_charAt(s2,4) = */
    ldr r0, =sz9_prompt         // load stage 9 prompt
    bl putstring                // libbarnet::putstring(sz9_prompt)

    ldr r0, =szS2               // load S2
    mov r1, #4                  // load integer literal
    bl String_charAt            // String_charAt(szS2, 4)
    bl emitCh                   // emitCh(String_charAt(szS2, 4))
    ldr r0,  =szSingleQuote     // load single quote
    bl putstring                // libbarnet::putstring(String_charAt)
    bl emitNewline              // emit a newline

stage10:
    /* 10. String_startsWith_1(s1,11,"hat.") =  */
    ldr r0, =sz10_prompt        // load prompt
    bl putstring                // libbarnet::putstring(sz10_prompt)

    ldr r0, =szS1               // load s1
    ldr r1, =sz10               // load "hat."
    mov r2, #11                 // load integer 11
    bl String_startsWith_1      // String_startsWith_1(s1,11,"hat.")
    bl emitBool                 // emitBool(String_startsWith_1(s1,11,"hat."))
    bl emitNewline              // emitNewline()

stage11:
    /* 11. String_startsWith_2(s1,"Cat") = */
    ldr r0, =sz11_prompt        // load prompt
    bl putstring                // libbarnet::putstring(sz11_prompt)

    ldr r0, =szS1               // load s1
    ldr r1, =sz11               // load "Cat"
    bl String_startsWith_2      // String_startsWith_2(s1,"Cat")
    bl emitBool                 // emitBool(String_startsWith_2(s1,"Cat"))
    bl emitNewline              // emitNewline()
stage12:
    /* 12. String_endsWith(s1,"in the hat.") */
    ldr r0, =sz12_prompt        // load prompt
    bl putstring                // libbarnet::putstring(sz12_prompt)

    ldr r0, =szS1               // load s1
    ldr r1, =sz12               // load "in the hat."
    bl String_endsWith          // String_endsWith(s1,"in the hat.")
    bl emitBool                 // emitBool(String_endsWith(s1,"in the hat."))
    bl emitNewline              // emitNewline()

stage13:
    /* String_indexOf_1(s2,'g') =  */
    ldr r0, =sz13_prompt
    bl putstring                // libbarnet::putstring(sz13_prompt)

    ldr r0, =szS2               // load S2
    ldr r1, =b13                // load 'g'
    ldrb r1, [r1]               // do deref char ptr.
    bl String_indexOf_1         // String_indexOf_1(s2,'g') =
    ldr r1, =szBuffer
    bl emitNumber               // emitNumber(String_indexOf_1(s2,'g'))
    bl emitNewline              // emitNewline()

stage14:
    /* 14. String_indexOf_2(s2,'g',9) */;
    ldr r0, =sz14_prompt
    bl putstring                // libbarnet::putstring(sz14_prompt)

    ldr r0, =szS2               // load S2
    ldr r1, =b13                // load 'g'
    ldrb r1, [r1]               // do deref char ptr.
    mov r2, #9                  // load int literal
    bl String_indexOf_2         // String_indexOf_2(s2,'g',9) =
    ldr r1, =szBuffer
    bl emitNumber               // emitNumber(String_indexOf_2(s2,'g',9))
    bl emitNewline              // emitNewline()

stage15:
    /*  String_indexOf_3(s2,"eggs") */
    ldr r0, =sz15_prompt
    bl putstring                // libbarnet::putstring(sz15_prompt)

    ldr r0, =szS2               // load S2
    ldr r1, =sz15                // load 'eggs'
    bl String_indexOf_3         // String_indexOf_3(s2,"eggs") =
    ldr r1, =szBuffer
    bl emitNumber               // emitNumber( String_indexOf_3(s2,"eggs"))
    bl emitNewline              // emitNewline()

stage16:
    /* 16. String_lastIndexOf_1(s2,'g') */
    ldr r0, =sz16_prompt
    bl putstring                // libbarnet::putstring(sz16_prompt)

    ldr r0, =szS2               // load S2
    ldr r1, =b13                // load 'g'
    ldrb r1, [r1]               // do deref char ptr.
    bl String_lastindexOf_1     // String_lastIndexOf_1(s2, 'g')
    ldr r1, =szBuffer
    bl emitNumber               // emitNumber(String_lastIndexOf_1(s2, 'g'))
    bl emitNewline              // emitNewline()

stage17:
    /* 17. String_lastIndexOf_2(s2,'g',6) = */
    ldr r0, =sz17_prompt
    bl putstring                // libbarnet::putstring(sz17_prompt)

    ldr r0, =szS2               // load S2
    ldr r1, =b13                // load 'g'
    ldrb r1, [r1]               // do deref char ptr.
    mov r2, #6                  // load literal 6
    bl String_lastIndexOf_2     // String_lastIndexOf_2(s2, 'g', 6)
    ldr r1, =szBuffer
    bl emitNumber               // emitNumber(String_indexOf_2(s2,'g',9))
    bl emitNewline              // emitNewline()

stage18:
    /* 18. String_lastIndexOf_3(s2,"egg") =  */
    ldr r0, =sz18_prompt
    bl putstring                // libbarnet::putstring(sz18_prompt)

    ldr r0, =szS2               // load S2
    ldr r1, =sz18                // load 'egg'
    bl String_lastIndexOf_3     // String_lastIndexOf_3(s2, 'egg')
    ldr r1, =szBuffer
    bl emitNumber               // emitNumber(String_lastIndexOf_3(s2, 'egg'))
    bl emitNewline              // emitNewline()

stage19:
    /* 19. String_replace(s1,'a','o') = */
    ldr r0, =sz19_prompt        // load prompt
    bl putstring                // libbarnet::putstring(sz18_prompt)

    ldr r0, =szS1               // load s1
    mov r1, #'a'                // load literals
    mov r2, #'o'                // load literals
    bl String_replace           // new_str = String_replace(s1,'a','o')
    push {r0}                   // track dynamic alloc
    bl putstring                // libbarnet::putstring(new_str)
    pop {r0}                    // restore ptr
    bl free                     // libc::free(new)str)
    ldr r0, =szQuote            // load szQuote
    bl putstring                // libbarnet::pustring("\"")
    bl emitNewline              // emitNewline()

stage20:
    /* 20. String_toLowerCase(s1) = */
    ldr r0, =sz20_prompt        // load prompt
    bl putstring                // libbarnet::putstring(sz18_prompt)

    ldr r0, =szS1               // load s1
    bl String_toLowerCase       // new_str = String_toLowerCase(szS1)
    push {r0}                   // track dynamic alloc
    bl putstring                // libbarnet::putstring(new_str)
    pop {r0}                    // restore ptr
    bl free                     // libc::free(new)str)
    ldr r0, =szQuote            // load szQuote
    bl putstring                // libbarnet::pustring("\"")
    bl emitNewline              // emitNewline()

stage21:
    /* 21. String_toUpperCase(s1) = */
    ldr r0, =sz21_prompt        // load prompt
    bl putstring                // libbarnet::putstring(sz18_prompt)

    ldr r0, =szS1               // load s1
    bl String_toUpperCase       // new_str = String_toUpperCase(szS1)
    push {r0}                   // track dynamic alloc
    bl putstring                // libbarnet::putstring(new_str)
    pop {r0}                    // restore ptr
    bl free                     // libc::free(new)str)
    ldr r0, =szQuote            // load szQuote
    bl putstring                // libbarnet::pustring("\"")
    bl emitNewline              // emitNewline()

stage22:
    /* concat(concat(s1, " "), s2) */
    ldr r0, =sz22_prompt_a      // load prompt a
    bl putstring                // libbarnet::putstring(sz22_prompt_a)
    ldr r0, =sz22_prompt_b      // load prompt b
    bl putstring                // libbarnet::putstring(sz22_prompt_b)

    ldr r0, =szS1               // load s1
    ldr r1, =sz22               // load " "
    bl String_concat            // r0 = String_concat(s1, " ")
    push {r0}                   // track dynamic alloc
    ldr r1, =szS2               // load S2
    bl String_concat            // r0 = String_concat(r0, s2)
    push {r0}                   // track dynamic alloc
    bl putstring                // libbarnet::putstring(<built string>)


    pop {r0}                    // free dynamic alloc
    bl free                     // libc::free(<intermediate dynaic alloc string>)
    pop {r0}                    // free dynamic alloc
    bl free                     // libc::free(<intermediate dynaic alloc string>)
    mov r0, #0                  // SAFETY: prevent use-after-free

    ldr r0, =szQuote            // load szQuote
    bl putstring                // libbarnet::pustring("\"")
    bl emitNewline              // emitNewline()

program_exit:
    /* end code section */
	// quit.
	// we are a normal function call now since libc is the entry point
	// so we need to adhere to AAPCS and return to the caller (libc entry-point)
    pop {lr}
    pop {r4-r8, r10,r11}
    mov r0, #0      // r0 contains the exit code, "return 0"
    bx lr           // ret2libc

// emitNumber(value: word, buffer: *char)
// accepts a number in r0 and a ptr to a string buffer in r1, emits number from r0 using r1 for storage.
emitNumber:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
/* convert to string */
    bl intasc32         // libbarnet::intasc32(word, buffer)
    cpy r0, r1          // move r1 string buffer to r0
    bl putstring        // libbarnet::putstring(libbarnet::intasc32(r0, szSum))
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// Emits a newline (lf).
// emitNewline()
emitNewline:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
/* output */
    ldr r0, =szLF       // prepare szLF for printing
    bl putstring        // libbarnet::putstring("\n")
    // return
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr


// emits boolean TRUE/FALSE
// emitBool(truth: bool)
emitBool:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
/* output */
    cmp r0, #0

    ldreq r0, =szFalse    // if r0 is False, load False
    ldrne r0, =szTrue     // otherwise load true
    bl putstring          // libbarnet::putstring(r0 ? "TRUE": "FALSE")
    // return
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// emits character
// emitChar(value: char)
// mainly because libbarnet::putstring requires a pointer....
emitCh:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}

    cpy r4, r0          // preserve input char
    mov r0, #1          // request one element
    mov r1, #1          // of size 1
    bl malloc           // buffer = malloc(1,1)
    push {r0}           // keep track of dynamic memory
    strb r4, [r0]       // load value char into dynamic memory
    bl putch            // libbarnet::putch(buffer)
    // cleanup
    pop {r0}            // restore ptr to buffer
    bl free             // libc::free(buffer)
    mov r0, #0          // SAFETY: prevent use-after-free

    // return
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

	.end
