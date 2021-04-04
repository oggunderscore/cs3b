/*
 * Joshua Salzedo's RASM3 String1 implementation
 */

    .text
    .global String_equals
    .global String_equalsIgnoreCase
    .global String_copy
    .global String_Copy_With_Start_Offset
    .global String_substring_1
    .global String_substring_2
    .global String_charAt
    .global String_startsWith_2
    .global String_startsWith_1
    .global String_endsWith
// Compare two strings for equality
// String_equals(a: *char, b: *char)
// ARGUMENTS:
// R0: (*char) ptr to string 1
// R1: (*char) ptr to string 2
// RETURNS:
// R0: boolean string1 == string2
String_equals:
        // preserve AAPCS registers
        push {r4-r8, r10,r11}
        push {lr}
        cpy r4, r0                      // persist string1 to r4 for safe keeping
        cpy r5, r1                      // persist string2 to r5 for safe keeping
        b _str_eq_len_check             // unconditional branch to precondition checl
_str_eq_len_check:
        cpy r0, r4                      // load string1 into r0
        bl strLen                       // r0 = strLen(string1)
        cpy r6, r0                      // r6 = strLen(string1)
        cpy r0, r5                      // load string2 into r0 for strLen
        bl strLen                       // r0 = strLen(string2)
        cpy r7, r0                      // r7 = strLen(string2)
        cmp r6, r7                      // len(string1) == len(string2)
        bne _str_eq_not_equal           // if(len(string1) != len(string2): {return false}
        b _str_eq_bytewise_init         // sigh, we are going to have to do this the hard way.

_str_eq_bytewise_init:
    mov r6, #0                          // r6 := i = 0
    b _str_eq_bytewise_loop             // unconditional branch to loop.
_str_eq_bytewise_loop:                  // while string1[i] != NULL {
    ldrb r7, [r4, r6]                   // load char from string1+i
    ldrb r8, [r5, r6]                   // load char from string2+i
    cmp r7, r8                          // string1[i] == string2[i]
    bne _str_eq_not_equal               // if (string1[i] != string2[i]) {return false}
    cmp r7, #0                          // string1[i] == NULL
    beq _str_eq_equates                 // if(string1[i] == NULL) {return true}
    add r6, r6, #1                      // counter += 1
    b _str_eq_bytewise_loop             // not at end of string1, not unequal: loop.

_str_eq_equates:
    mov r0, #1                          // load TRUE into r0
    b _str_eq_exit                      // and exit

_str_eq_not_equal:
    mov r0, #0                          // load FALSE into r0
    b _str_eq_exit                      // and exit

_str_eq_exit:
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr

/// Dynamically allocates an identical string
/// ARGUMENTS
/// String_copy(origin: *char) -> *char
/// R0 : (*char) string
/// RETURNS
/// R0: (*char) duplicated string
String_copy:
        // preserve AAPCS registers
        push {r4-r8, r10,r11}
        push {lr}
        cpy r4, r0                          // r4 := originString = r0
        bl strLen                           // r0 := strLen(r0)
        add r0, #1
        cpy r5, r0                          // r5 := length = strLen(r0)
        /* void *calloc(size_t nmemb, size_t size) */
        /*        The calloc() function allocates memory for an array of nmemb elements
                  of size bytes each and returns a pointer to the allocated memory.
                  The memory is set to zero. */
                    // r0 already contains length, which is the number of requisite members
        mov r1, #1  // each element is 1 byte long.
        bl calloc   // calloc(r0, 1); // allocate r0 := len(originString) bytes of memory
        // r0 := new_string
        b _string_copy_loop_init    // move to next step.
_string_copy_loop_init:
        mov r1, #0  // r1 := i = 0
_string_copy_loop_top:
        ldrb r7, [r4, r1]           //  load byte from originString[i]
        cmp r7, #0                  //  check if byte is NULL
        beq _string_copy_exit       //  if (char == NULL) {break}
        strb r7, [r0,r1]            // new_string[i] = originString[i]
        add r1, r1, #1              //  counter += 1
        b _string_copy_loop_top     // }

_string_copy_exit:
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr

// caseless equality operation between ASCII strings
// String_equalsIgnoreCase(a: *char, b: *char)
// ARGUMENTS:
// R0: string A
// R1: string B
// RETURNS:
// R0: boolean equality
String_equalsIgnoreCase:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
    cpy r5, r1                      // String B

    bl String_toLowerCase           // r0 = RASM3::String_toLowerCase(A)
    push {r0}                       // push allocated ptrs to stack for easy retrieval
    cpy r4, r0                      // preserve ptr to lowercased A
    cpy r0, r5                      // load ptr to source B
    bl String_toLowerCase           // r0 = RASM3::String_toLowerCase(B)
    push {r0}                       // push allocated ptrs to stack for easy retrieval
    /* r0 has lowercased B */
    cpy r1, r4                      // restore ptr to lowercased A
    // String_equals(a: *char, b: *char)
    bl String_equals                // String_equals(b, a)
    cpy r7, r0                      // cache computational result
    /* restore stack and free dynamic memory */
    pop {r0}                        // pop ptr to dynamic memory no longer needed
    bl free                         // libc::free(lowercase_a)
    pop {r0}                        // pop ptr to dynamic memory no longer needed
    bl free                         // libc::free(lowercase_b)

    cpy r0, r7                        // restore computational result
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// String_substring_1(input: *char, i: word, N: word)
// Returns the substring at input[i:n]
// PARAMETERS:
// R0: *char input
// R1: WORD offset i
// R2: WORD offset N
// RETURNS
// R0: *char substring
// PRECONDITIONS:
//      i < len(input). this function will return NULL if this condition is not satisfied.
//      n > i > len(input). undefined behavior.
String_substring_1:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0                      // r4 := original_str = r0
    cpy r5, r1                      // r5 := i = r1
    cpy r6, r2                      // r6 := n =  r2
    // figure out how long this string is
    bl strLen                       // strLen(original_str)
    // and subtract n from that, to determine the number of bytes being copied.
    sub r6, r0, r6                  //  n = strLen(original_str) - n
    cpy r0, r4                      // restore these pointers after calling strLen
    cpy r1, r5                      // restore these pointers after calling strLen

    bl String_Copy_With_Start_Offset // see next line (too long)
    // r0 := intermediate =  String_Copy_With_Start_Offset(input, i);

    cpy r4, r0                      // r4 := intermediate = r0
    bl strLen                       // r0 := intermediate_len = strLen(intermediate)
    sub r1, r0, r6                  // r1 := i = intermediate_len - n
    cpy r0, r4                      // r0 = intermediate
    mov r7, #0                      // load a null into r7
    /*
     * Slicing in a more memory efficient way proved troublesome, so instead
     * This abuses the fact c-strings are null-terminated.
     */
    strb r7, [r0,r1]                // intermediate[end]=NULL


    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr


// Returns the substring at input[i:]
// String_substring_2(input: *char, i: word) -> *char
// PARAMETERS:
// R0: *char input
// R1: WORD offset i
// RETURNS
// R0: *char substring
// PRECONDITIONS:
//      i < len(input). this function will return NULL if this condition is not satisfied.
String_substring_2:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
    bl String_Copy_With_Start_Offset  // return String_Copy_With_Start_Offset(input, i);

_string_substring_2_exit:
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr


// Returns a null-terminated copy of input[offset:] with the corresponding length
// String_Copy_With_Start_Offset(original: *char, offset: word)
// PARAMETERS:
// r0: *char original string to duplicate
// r1: word input offset, set to zero for a full length duplicate
// RETURNS: r0: *char to new dynamically allocated duplicate of length len(input)-offset+1
// PRECONDITIONS
// len(input) - offset > 0; returns NULL if negative
String_Copy_With_Start_Offset:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0                      //  r4 := original_str
    cpy r5, r1                      //  r5 := offset
    bl strLen                       //  r0 := strLen(original_str)
    subs r0, r0, r5                 //  r0 -= offset
    // if ( strLen(originalStr) - offset < 0) {
        blt _str_copy_with_offset_failed_precondition //  return NULL
    // }
    mov r6, #0                      // r6 := i
    cpy r7, r5                      // r7 := i+offset
    /* r0 already holds length */
    mov r1, #1                      // r1 = 1
    bl calloc                       // libc::calloc(length, 1)
    b _str_copy_loop_top

_str_copy_with_offset_failed_precondition:
    mov r0, #0                      // load NULL into r0
    b _str_copy_with_offset_exit    // return NULL

_str_copy_loop_top:
ldrb r8, [r4, r7]                   // r8 := current_char = original_str[i+offset]
strb r8, [r0, r6]
/* while origin[offset+i] != NULL */
cmp r8, #0                          // original_str[i+offset] == NULL
beq _str_copy_with_offset_exit      // return
add r6, r6, #1                      // increment destination offset r6 (i)
add r7, r7, #1                      // increment source offset r7

b _str_copy_loop_top

_str_copy_with_offset_exit:
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr


// Returns the char at string[i]
// PARAMETERS:
// R0: char* string
// R1: word i
// RETURNS:
// R0: char string[i]
String_charAt:
    // preserve AAPCS registers
    push {r4-r8, r10,r11}
    push {lr}
    ldrb r0, [r0, r1]   // r0 = string[i]
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// String_startsWith_2(string: *char, prefix *char)
//
String_startsWith_2:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0  // r4:= original
    cpy r5, r1  // r5:= substring
    cpy r0, r5  // load substring
    bl strLen   // r0 := i = strLen(substring)
    cpy r2, r0  // move result to r2
    mov r1, #0  // move zero into r1 for i
    cpy r0, r4  // move ptr to original back into r0

    // String_substring_1(input: *char, i: word, N: word)

    bl String_substring_1   // r0 := prefix = String_substring_1(
                            //      original,
                            //      0,
                            //      len(substring)
                            // )
    push {r0}               // track dynamic memory

    cpy r1, r5              // restore substring to r1
    bl String_equals        // StringEquals(prefix, substring)
    cpy r7, r0              // cache equality result temporarially
    pop {r0}                // restore ptr to allocated substring
    bl free                 // libc::free(prefix)
    cpy r0, r7              // restore equality result

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// String_startsWith_1(original: *char, prefix: *char, offset: word)
// asserts that `prefix` exists at original[offset:]
// PARAMETERS:
// R0: *char original
// R1: *char prefix
// R2: word offset
// RETURNS:
// R0: boolean
String_startsWith_1:
    push {r4-r8, r10,r11}
    push {lr}
    /* METHOD:
     * take the substring origin[offset:] and pass that to String_startsWith_2
     */
    // String_Copy_With_Start_Offset(original: *char, offset: word)
    cpy r4, r0                          // r4 := original = r0
    cpy r5, r1                          // r5 := prefix = r1
    cpy r6, r2                          // r6 := offset = r2

    cpy r1, r6                          // r1 = offset
    bl String_Copy_With_Start_Offset    // r0 := substr = String_Copy_With_Start_Offset (
                                        //  original,
                                        //  offset
                                        // )
    push {r0}                           // preserve dynamiclly allocated str for later free

    // String_startsWith_2(string: *char, prefix *char)
    cpy r1, r5
    bl String_startsWith_2              // String_startsWith_2(r0, prefix)
    cpy r8, r0                          // preserve compute result

    pop {r0}                            // restore dynamic alloc ptr
    bl free                             //libc::free(substr)
    cpy r0, r8                          // restore compute result

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// asserts whether `suffix` terminates `original`
// String_endsWith(original: string, suffix:string)
String_endsWith:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0              // r4 := original
    cpy r5, r1              // r5 := suffix
    bl strLen               // r0 = strLen(original)
    cpy r6, r0              // r6 := original_len
    cpy r0, r5              // r0 = suffix
    bl strLen               // r0 = strLen(suffix)
    cpy r7, r0              // r7 := suffix_len
    // String_substring_2(input: *char, i: word) -> *char
    sub r1, r6, r7          // i = original_len - suffix_len
    cpy r0, r4              // input = original
    bl String_substring_2   // r0 = String_substring_2(original, original_len - suffix_len)
    push {r0}               // push substring to stack so we can get it later...

    // String_equals(a: *char, b: *char)
    cpy r1, r5
    bl String_equals        // String_equals(substring, suffix)

    cpy r8, r0              // persist equality result for a step
    // libc::free(*void)
    pop {r0}                // restore ptr to substring
    bl free                 // libc::free(substring)

    cpy r0, r8              // restore equality result

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr
.end
