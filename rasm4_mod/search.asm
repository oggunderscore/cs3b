.text

.global is_substring
.global find_substring_node
.global walk_ll_substrings
.equ NODE_DATA_OFFSET, 0
.equ NODE_NEXT_OFFSET, 4
.equ NODE_PREVIOUS_OFFSET, 8


// bool is_substring(substring:str , superstring:str);
// asserts whether a is a substring of B or not, caseless.
is_substring:

        push {r4-r8, r10,r11}
        push {lr}

        //int String_indexOf_3(char *superstring, char *substring);
        push {r0}
        push {r1}
        pop {r0}
        pop {r1}

        bl String_indexOf_3 // i := r0 = String_indexOf_3(b, a);
        cmp r0, #0         // if (i == -1) {
            movlt r0, #0        // return false
        // } else {
            movge r0, #1        // return true
        // }
        pop {lr}
        pop {r4-r8, r10,r11}
        bx lr

// bool find_substring_node(*Node head, char *substring);
// Walks the linked list from `head` and returns if it found any matching substrings in LL
walk_ll_substrings:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0      // r4:= current_node = head

    cpy r0, r1      // load substring to r1 for tolower
    bl String_toLowerCase   // String_toLowerCase(substring)
    push {r0}               // NOTICE: dynamicalloc 1
    cpy r5, r0              // r5 := lowered_substr

    mov r6, #0      // r6 := i = 0
    mov r7, #0      // r7 := found_any = False

_walk:
    /* check if we should continue walking */
    cmp r4, #0              // while current_node != NULL
    beq _walk_substr_ret    // bail out of loop if the nodeis NULL

    /* load current node's data */
    ldr r0, [r4, #NODE_DATA_OFFSET] // load r0 with node data
    /* cast current node's data to lowercase */
    bl String_toLowerCase           // r0 := superstring = String_toLowerCase(current->data)
    push {r0}                       // NOTICE: dynamicalloc 1+1=2
    cpy r1, r0                      // load lowercase superstring to r1 arg B
    cpy r0, r5                      // load lowercase substring to r0 arg A

    // bool is_substring(a:str , b:str);
    bl is_substring                 // is_substring(substring, superstring);

    /* check if it is a substring */
    cmp r0, #1                      // if is_substring(substring, superstring) {
        moveq r7, #1                // found_any = True
        cpyeq r0, r6                // copy i into r0
        bleq printLoc               // printLoc(i)
    // }
    add r6, #1                      // i+=1
    pop {r0}                        // NOTICE: dynamicalloc 2-1=1
    bl free                         // free dynamic memory from walk

    ldr r4, [r4, #NODE_NEXT_OFFSET] // current = current -> next;

    b _walk                         // loop.

_walk_substr_ret:
    pop {r0}                        // libc::free(superstring)
    bl free                         // NOTICE: 1dynamicalloc 1-1 = 0
    cpy r0, r7                      // return found_any

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

.end