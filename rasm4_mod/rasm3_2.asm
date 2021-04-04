/*
        Kevin Nguyen's Rasm3 String2.s Documentation

        Initial Date: 10/22/20
        Finish Date: 10/26/20
*/

.global     String_indexOf_1
.global     String_indexOf_2
.global     String_indexOf_3
.global     String_lastindexOf_1
.global     String_lastIndexOf_2
.global     String_lastIndexOf_3
.global     String_concat
.global     String_toLowerCase
.global     String_toUpperCase
.global     String_replace

/*
    r0 = Pointer to String to search for specified Char
    r1 = Char c to search within r0
    r2 = Current Index Iterator
    r3 = Found Index Location
    r4 = Saved Char c

    r0 will contain the resulted index of the first char found in str
    If not found, returns -1
*/


String_indexOf_1:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    mov         r4,     r1                      @ Moving value

    mov         r2,     #0x0                    @ Reset Counters
    mov         r3,     #-1                     @ Reset Counters

    b           String_indexOf_1_loop           @ Start Loop

String_indexOf_1_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_indexOf_1_exit           @ Exit if end of line
    cmp         r1,     r4                      @ Compare if current char = desired char
    moveq       r3,     r2                      @ Move current index into result r3
    beq         String_indexOf_1_exit           @ Exit if char has been found
    add         r2,     #0x1                    @ Increment Current Index
    b           String_indexOf_1_loop           @ Else, iterate and loop

String_indexOf_1_exit:
    mov         r0,     r3                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call
    
/*
    r0 = Pointer to String to search for specified Char
    r1 = Char c to search within r0
    r2 = Current Index Iterator
    r3 = Found Index Location
    r4 = Saved Char c
    r5 = Saved Starting Index
    r0 will contain the resulted index of the first char found in str
    If not found, returns -1
*/

String_indexOf_2:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    mov         r4,     r1                      @ Moving value

    mov         r5,     r2                      @ Take the starting index and store to r5

    mov         r2,     #0x0                    @ Reset Counters
    mov         r3,     #-1                     @ Reset Counters

    b           String_indexOf_2_loop           @ Start Loop

String_indexOf_2_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_indexOf_2_exit           @ Exit if end of line
    
    cmp         r2,     r5                      @ Check if current index = starting index
    addlt       r2,     #0x1                    @ Increment Current Index
    blt         String_indexOf_2_loop           @ Iterate
    
    cmp         r1,     r4                      @ Compare if current char = desired char
    moveq       r3,     r2                      @ Move current index into result r3
    beq         String_indexOf_2_exit           @ Exit if char has been found
    add         r2,     #0x1                    @ Increment Current Index
    b           String_indexOf_2_loop           @ Else, iterate and loop

String_indexOf_2_exit:
    mov         r0,     r3                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

/*
    r0 = Pointer to String to search for specified Char
    r1 = String str to search within r0
    r2 = Current Index Iterator
    r3 = Found Index Location & Flag usage for ifFound()
    r4 = Saved Str

    r0 will contain the resulted index of the first char found in str
    If not found, returns -1

    Flag: 
    -1  = Error, could not find in String
    0   = Working on search, not found in current index
    1   = Found string
*/

/*
    r0 = Current Active String Pointer
    r1 = Current str to find in r0
    r2 = Index counter from main function String_indexOf_3
    r3 = Flag
    r4 = Active Search String
    r5 = Active Char from Search String
    r6 = Relpica of original Search String
    r7 = Copy of Current Active String Pointer
*/

checkStr1:       @ Ex: "I Like Blue", "Li"

    @ Assuming r3 is 0, this will be the count for how many times we load bit
    @ At this point the first char from the loop is already loaded into r1
    @ We will load into r5 the first char from r4 (string to be found)
    ldrb        r5,     [r4], #0x1              @ Load from comparison string into r5, and inc.

    cmp         r5,     #0x0                    @ Check if end of search
    beq         checkStrExit1                   @ Return to main function loop


    cmp         r1,     r5                      @ Compare the two chars

    moveq       r3,     #0x1                    @ Load success
    movne       r3,     #0x0                    @ Load fail
    bne         checkStrExit1                   @ If any check fails, exit
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    b           checkStr1                       @ Recursively Call self



checkStrExit1:

    cpy         r0,     r7                      @ Reset Index Oriignal String
    cpy         r4,     r6                      @ Reset searcher
    @   Since flag was still 0 at start, reiterate.

    add         r2,     #0x1                    @ Increment Current Index
    b           String_indexOf_3_loop           @ Else, iterate and loop

//int String_indexOf_3(char *superstring, char *substring);
String_indexOf_3:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    mov         r4,     r1                      @ Moving value
    cpy         r6,     r4                      @ Copy original address to r6

    mov         r2,     #0x0                    @ Reset Counters
    mov         r3,     #0x0                    @ Reset Counters

    b           String_indexOf_3_loop           @ Start Loop

String_indexOf_3_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment

    cpy         r7,     r0                      @ Save current Location

    cmp         r1,     #0x0                    @ Compare to end of line
    moveq       r3,     #-1                     @ Load Error into result
    beq         String_indexOf_3_exit           @ Exit if end of line

    cmp         r3,     #0x0                    @ Check status of flag, -1, 0, or 1
    mov         r3,     #0x0                    @ Reset flag

    movgt       r3,     r2                      @ If r3 flag is found, then return index to r3
    bgt         String_indexOf_3_exit           @ Exit program since string has been found
    bleq        checkStr1                       @ Check the string for Str

String_indexOf_3_exit:
    sub         r3,     #1                      @ Fix off-by-one
    mov         r0,     r3                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

/*
    r0 = Pointer to String to search for specified Char
    r1 = Char c to search within r0
    r2 = Current Index Iterator
    r3 = Found Index Location
    r4 = Saved Char c
    r0 will contain the resulted index of the first char found in str
    If not found, returns -1
*/

String_lastindexOf_1:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    mov         r4,     r1                      @ Moving value
    
    mov         r5,     r2                      @ Take the starting index and store to r5

    mov         r2,     #0x0                    @ Reset Counters
    mov         r3,     #-1                     @ Reset Counters

    b           String_lastindexOf_1_loop       @ Start Loop

String_lastindexOf_1_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_lastindexOf_1_exit       @ Exit if end of line
    cmp         r1,     r4                      @ Compare if current char = desired char
    moveq       r3,     r2                      @ Move current index into result r3
    
    add         r2,     #0x1                    @ Increment Current Index
    b           String_lastindexOf_1_loop       @ Else, iterate and loop

String_lastindexOf_1_exit:
    mov         r0,     r3                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

/*
    r0 = Pointer to String to search for specified Char
    r1 = Char c to search within r0
    r2 = Current Index Iterator
    r3 = Found Index Location
    r4 = Saved Char c
    r5 = Saved Starting Index
    r0 will contain the resulted index of the first char found in str
    If not found, returns -1
*/

String_lastIndexOf_2:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    mov         r4,     r1                      @ Moving value 

    mov         r5,     r2                      @ Take the starting index and store to r5

    mov         r2,     #0x0                    @ Reset Counters
    mov         r3,     #-1                     @ Reset Counters

    b           String_lastIndexOf_2_loop       @ Start Loop

String_lastIndexOf_2_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_lastIndexOf_2_exit       @ Exit if end of line
    
    cmp         r2,     r5                      @ Check if current index = starting index
    addlt       r2,     #0x1                    @ Increment Current Index
    blt         String_lastIndexOf_2_loop       @ Iterate
    
    cmp         r1,     r4                      @ Compare if current char = desired char
    moveq       r3,     r2                      @ Move current index into result r3
    
    add         r2,     #0x1                    @ Increment Current Index
    b           String_lastIndexOf_2_loop       @ Else, iterate and loop

String_lastIndexOf_2_exit:
    mov         r0,     r3                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

/*
    r0 = Pointer to String to search for specified Char
    r1 = String str to search within r0
    r2 = Current Index Iterator
    r3 = Found Index Location & Flag usage for ifFound()
    r4 = Saved Str

    r0 will contain the resulted index of the first char found in str
    If not found, returns -1

    Flag: 
    -1  = Error, could not find in String
    0   = Working on search, not found in current index
    1   = Found string
*/

/*
    r0 = Current Active String Pointer
    r1 = Current str to find in r0
    r2 = Index counter from main function String_indexOf_3
    r3 = Flag
    r4 = Active Search String
    r5 = Active Char from Search String
    r6 = Relpica of original Search String
    r7 = Copy of Current Active String Pointer
*/

checkStr2:       @ Ex: "I Like Blue", "Li"

    @ Assuming r3 is 0, this will be the count for how many times we load bit
    @ At this point the first char from the loop is already loaded into r1
    @ We will load into r5 the first char from r4 (string to be found)
    ldrb        r5,     [r4], #0x1              @ Load from comparison string into r5, and inc.

    cmp         r5,     #0x0                    @ Check if end of search
    beq         checkStrExit2                   @ Return to main function loop


    cmp         r1,     r5                      @ Compare the two chars

    moveq       r3,     #0x1                    @ Load success
    movne       r3,     #0x0                    @ Load fail
    bne         checkStrExit2                   @ If any check fails, exit
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    b           checkStr2                       @ Recursively Call self



checkStrExit2:

    cpy         r0,     r7                      @ Reset Index Oriignal String
    cpy         r4,     r6                      @ Reset searcher
    @   Since flag was still 0 at start, reiterate.

    b           String_lastIndexOf_3_loop       @ Else, iterate and loop


String_lastIndexOf_3:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    mov         r4,     r1                      @ Moving value
    cpy         r6,     r4                      @ Copy original address to r6

    mov         r2,     #0x0                    @ Reset Counters
    mov         r3,     #0x0                    @ Reset Counters

    b           String_lastIndexOf_3_loop       @ Start Loop

String_lastIndexOf_3_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment

    cpy         r7,     r0                      @ Save current Location

    cmp         r1,     #0x0                    @ Compare to end of line
    moveq       r3,     #-1                     @ Load Error into result
    beq         String_lastIndexOf_3_exit           @ Exit if end of line

    cmp         r3,     #0x0                    @ Check status of flag, -1, 0, or 1
    mov         r3,     #0x0                    @ Reset flag

    movgt       r8,     r2                      @ If r3 flag is found, then return index to r8

    add         r2,     #0x1                    @ Increment Current Index

    bl          checkStr2                       @ Check the string for Str

    @ Instead of exiting, iterate until end of main string to find last match.

    b           String_lastIndexOf_3_loop       @ Reiterate

String_lastIndexOf_3_exit:
    sub         r8,     #0x1                    @ Sub by 1
    mov         r0,     r8                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

/*
    r0 = String 1
    r1 = String 2 & Counter
    r2 = Unused
    r3 = Unused
    r4 = String 1 Copy
    r5 = Mem Size
    r6 = String 2 Copy

    *Modified version of String_copy
*/

String_concat:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    cpy         r4,     r0                      @ Copy String 1 to r4
    cpy         r6,     r1                      @ Copy String 2 to r6
    bl          strLen                          @ Get Length of String 1
    cpy         r5,     r0                      @ Copy that value to r5
    cpy         r0,     r6                      @ Copy String 2 into r0 for memSize
    bl          strLen                          @ Get String 2 Size
    add         r5,     r0                      @ r5 += r0, So we get total size of both Str
    cpy         r0,     r5                      @ Copy that total value into r0 for calloc

    mov         r1,     #0x1                    @ Element size of 1
    bl          calloc                          @ calloc(size) of new array
    b           String_concat_loop_init         @ Start the copy

String_concat_loop_init:
    mov         r1,     #0x0                    @ Set initial counter to 0

String_concat_loop_top:
    ldrb        r7,     [r4, r1]                @ Load Byte from String 1

    cmp         r7,     #0x0                    @ Check if end of string 1
    beq         String_concat_loop2             @ Start copying string 2

    str         r7,     [r0, r1]                @ Store into the new string
    add         r1,     #0x1                    @ Increment counter
    b           String_concat_loop_top          @ Reiterate

String_concat_loop2:

    ldrb        r7,     [r6], #1                @ Load char of second string and increment

    cmp         r7,     #0x0                    @ Check if end of str2
    beq         String_concat_exit              @ Exit concat

    str         r7,     [r0, r1]                @ Store char into r0 with offset r1
    add         r1,     #0x1                    @ Increment Pointer Counter
    b           String_concat_loop2

String_concat_exit:
    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Register
    bx          lr                              @ Return call

/*
    r0 = Pointer to String to use replace
    r1 = Current Char
    r2 = Current counter index
    r3 = Modified Address Pointer & Flag to checker
    r4 = Reference of Pointer to String to toLower
    r5 = Old Char
    r6 = New Char

*/

toReplace:
    cpy         r1,     r6                      @ Set current char to new char
    add         r3,     r4, r2                  @ r3 = Base Address of Str + Offset Iterator = Address of Char
    strb        r1,     [r3]                    @ Store that back into where r0 is with counter
    add         r2,     #0x1                    @ Increment Index Counter
    b           String_replace_loop

String_replace:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register
    
    cpy         r5,     r1                      @ Old char
    cpy         r6,     r2                      @ New char

    bl          String_copy                     @ Dynamically Allocate it

    cpy         r4,     r0                      @ Copy address


    mov         r2,     #0x0                    @ Reset Counters

    b           String_replace_loop             @ Start Loop


String_replace_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_replace_exit             @ Exit if end of line

    cmp         r1,     r5                      @ If current char == oldchar
    beq         toReplace

    add         r2,     #0x1                    @ Increment Index Counter
    b           String_replace_loop             @ Else, iterate and loop

String_replace_exit:
    mov         r0,     r4                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Registers
    bx          lr                              @ Return call


/*
    r0 = Pointer to String to toLower
    r1 = Current Char
    r2 = Current counter index
    r3 = Modified Address Pointer & Flag to checker
    r4 = Reference of Pointer to String to toLower

*/

toLower:
    add         r1,     #0x20                   @ Add 32 to current val to turn it capital
    add         r3,     r4, r2                  @ r3 = Base Address of Str + Offset Iterator = Address of Char
    strb        r1,     [r3]                    @ Store that back into where r0 is with counter
    add         r2,     #0x1                    @ Increment Index Counter
    b           String_toLowerCase_loop

String_toLowerCase:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    bl          String_copy                     @ Dynamically Allocate it

    cpy         r4,     r0                      @ Copy address

    mov         r2,     #0x0                    @ Reset Counters

    b           String_toLowerCase_loop         @ Start Loop

String_toLowerCase_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_toLowerCase_exit         @ Exit if end of line

    mov         r3,     #0x0                    @ Reset Flag

    cmp         r1,     #0x41                   @ If >= 'A'
    addge       r3,     #0x1                    @ Inc flag by 1
    cmp         r1,     #0x5A                   @ Check if <= 'Z'
    addle       r3,     #0x1                    @ Inc flag by 1

    cmp         r3,     #0x2                    @ If both pass, then it is CAPITAL, make lower
    beq         toLower

    add         r2,     #0x1                    @ Increment Index Counter
    b           String_toLowerCase_loop         @ Else, iterate and loop

String_toLowerCase_exit:
    mov         r0,     r4                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Registers
    bx          lr                              @ Return call

/*
    r0 = Pointer to String to toLower
    r1 = Current Char
    r2 = Current counter index
    r3 = Modified Address Pointer & Flag to checker
    r4 = Reference of Pointer to String to toLower

*/
toUpper:
    sub         r1,     #0x20                   @ Sub 32 to current val to turn it lowercase
    add         r3,     r4, r2                  @ r3 = Base Address of Str + Offset Iterator = Address of Char
    strb        r1,     [r3]                    @ Store that back into where r0 is with counter
    add         r2,     #0x1                    @ Increment Index Counter
    b           String_toUpperCase_loop


String_toUpperCase:
    push        {r4-r8, r10,r11}                @ Preserve Registers
    push        {lr}                            @ Preserve Link Register

    bl          String_copy                     @ Dynamically Allocate it

    cpy         r4,     r0                      @ Copy address

    mov         r2,     #0x0                    @ Reset Counters

    b           String_toUpperCase_loop         @ Start Loop

String_toUpperCase_loop:
    ldrb        r1,     [r0], #0x1              @ Load right most byte & increment
    cmp         r1,     #0x0                    @ Compare to end of line
    beq         String_toUpperCase_exit         @ Exit if end of line

    mov         r3,     #0x0                    @ Reset Flag

    cmp         r1,     #0x61                   @ If >= 'a'
    addge       r3,     #0x1                    @ Inc flag by 1
    cmp         r1,     #0x7A                   @ Check if <= 'z'
    addle       r3,     #0x1                    @ Inc flag by 1

    cmp         r3,     #0x2                    @ If both pass, then it is lowercase, make upper
    beq         toUpper

    add         r2,     #0x1                    @ Increment Index Counter
    b           String_toUpperCase_loop         @ Else, iterate and loop

String_toUpperCase_exit:
    mov         r0,     r4                      @ Move index to r0

    pop         {lr}                            @ Preserve Registers
    pop         {r4-r8, r10,r11}                @ Preserve Link Registers
    bx          lr                              @ Return call
