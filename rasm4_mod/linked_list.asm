    .data
.EQU LINKED_LIST_ELEMENTS, 3
.EQU LINKED_LIST_ELEM_SIZE, 4
.EQU HEAD_OFFSET, 0
.EQU TAIL_OFFSET, 4
.EQU LEN_OFFSET, 8
.equ NODE_DATA_OFFSET, 0
.equ NODE_NEXT_OFFSET, 4
.equ NODE_PREVIOUS_OFFSET, 8

.EQU NULL,  0
    .text
    .global LinkedList_push
    .global LinkedList
    .global LinkedList_len
    .global LinkedList_get_nth
     .global LinkedList_pop_n
    .global NULL
/*
struct LinkedList{
    *Node head;
    *Node tail;
    uint32_t size;
}

*/

// *LinkedList LinkedList()
LinkedList:
    push {r4-r8, r10,r11}
    push {lr}

    // void *calloc(size_t nmemb, size_t size);
    mov r0, #LINKED_LIST_ELEMENTS
    mov r1, #LINKED_LIST_ELEM_SIZE
    bl calloc   // calloc(LINKED_LIST_ELEMENTS, LINKED_LIST_ELEM_SIZE)
    // calloc zero-initializes the memory so LEN is already initialized for us.
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// Node *LinkedList_getHead(LinkedList* this) const;
// returns this->head.
LinkedList_getHead:
    push {r4-r8, r10,r11}
    push {lr}

    ldr r0, [r0, #HEAD_OFFSET]  // return this->head

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr
// Node *LinkedList_getTail(LinkedList* this) const;
// returns this->tail.
LinkedList_getTail:
    push {r4-r8, r10,r11}
    push {lr}

    ldr r0, [r0, #TAIL_OFFSET]  // return this->tail

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// LinkedList* LinkedList_push(LinkedList* this, void* data);
// Pushes specified `data` onto LinkedList `this`. returns `this`.
LinkedList_push:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0                  // preserve this
    cpy r0, r1                  // move data to r0 for Node ctor
    bl Node                     // new_node = Node(data); ctor
    cpy r5, r0                  // r5 := new_node

    ldr r6, [r4, #LEN_OFFSET]   // load length field
    add r6, #1                  // increment length field by one
    str r6, [r4, #LEN_OFFSET]   // store updated length


    cpy r0, r4                  // restore this
    bl LinkedList_getHead       // this->LinkedList_getHead
    cmp r0, #NULL               // if (this->getHead == NULL) {
        cpy r0, r4              // restore this
        beq _init_linked_list   // return _init_linked_list()
    // }
    /* the list *is* initialized, fetch this->tail */
    // else {
        cpy r0, r4                  // restore this
        bl LinkedList_getTail       // fetch this LL's tail, so we may append to it
        /* r0 now contains the tail Node */
        str r5, [r0, #NODE_NEXT_OFFSET]         // tail->next=new_node;
        str r0, [r5, #NODE_PREVIOUS_OFFSET]     // new_node->previous=tail
        str r5, [r4, #TAIL_OFFSET]              // this->tail = new_node
    // }

_push_exit:
    cpy r0, r4  // restore this
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// uint32_t LinkedList_len(LinkedList* this) const;
// returns the length of this linked list
LinkedList_len:
    push {r4-r8, r10,r11}
    push {lr}

    ldr r0, [r0, #LEN_OFFSET]     // return this->len

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

/// Node *LinkedList_get_nth(LinkedList* this, n: int) const;
/// fetches the Nth node of the LinkedList, if it exists.
/// returns NULL if n >= len(*this)
LinkedList_get_nth:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0                      // preserve this
    cmp r1, #0                      // if (n==0) {
        beq _get_nth_ret_head       // return this->head;
    // } else if ( n < 0 ){
        blt _get_nth_ret_null        // return NULL
    // }
    bl LinkedList_len               // r0 := this->len()
    cmp r1, r0                      // if (n>=this->len()){
        bge _get_nth_ret_null       //  return NULL
    sub r0, #1                      // if (n == this->len()-1) {
    cmp r0, r1
    beq _get_nth_ret_tail           //  return this->tail
    // }

    /* Sigh, out of edge cases. time to do this the HARD way. */
    mov r6, #0                      // r6 := i = 0
    mov r0, r4                      // restore this
    bl LinkedList_getHead           // r0 := current_node = this->getHead
    _getn_nth_traverse_top:         // while (current_node != NULL) {
        cmp r0, #NULL                   // if (current_node == NULL) {
            // exit condition
            beq _get_nth_ret_null         // return NULL
        // }
        cmp r6, r1                      // if (n == i) {
            beq _get_nth_ret            //  return current_node
        // }
        ldr r0, [r0, #NODE_NEXT_OFFSET]  // current_node = current_node->next
        add r6, #1                      // i += 1
        b _getn_nth_traverse_top
    // }
_get_nth_ret_head:
ldr r0, [r4, #HEAD_OFFSET]          // return this->head
b _get_nth_ret                      // return this->head

_get_nth_ret_tail:
ldr r0, [r4, #TAIL_OFFSET]          // return this->head
b _get_nth_ret

/* returns NULL */
_get_nth_ret_null:
mov r0, #NULL                       // return NULL
b _get_nth_ret                      // return NULL

_get_nth_ret:
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr
// init the linked list as the HEAD is NULL
_init_linked_list:
    str r5, [r4, #HEAD_OFFSET]  // this->head = new_node
    str r5, [r4, #TAIL_OFFSET]  // this->tail = new_node
    b _push_exit

/// Pops a value off the right of the LinkedList.
/// void* LinkedList_pop_left(LinkedList* this);
/// Note: this effectively pop's the HEAD
/// If (len(this) == 0 or this->head==NULL) this function does nothing.
/// The popped value is returned, though the node will be free'ed.
LinkedList_pop_left:
    push {r4-r8, r10,r11}
    push {lr}
    cmp r0, #NULL               // if (!this) {
    beq _popLeft_ret_null      //  return
    // }
    cpy r4, r0                  // preserve this
    bl LinkedList_len           // get length
    cmp r0, #0                  // if (this->len == 0) {
        bleq _popLeft_ret_null  //  return
    // }
    ldr r5, [r4, #HEAD_OFFSET]  // load head node
    ldr r6, [r4, #TAIL_OFFSET]  // load tail
    cmp r5, r6                  // if (this->head == this->tail) {
    beq _popLeft_become_empty   // return _popLeft_become_empty()
    /* this won't become empty with this pop, update self->head->previous and self->head.*/
    ldr r7, [r5, #NODE_NEXT_OFFSET]  // load r7 = next := this->head->next
    mov r8, #NULL
    str r8, [r7, #NODE_PREVIOUS_OFFSET] // next->previous = NULL
    str r7, [r4, #HEAD_OFFSET]  // update this->head = next
    cpy r0, r5                  // move old head to r0 for free
    ldr r5, [r0, #NODE_DATA_OFFSET] // retrieve its data before we free it
    push {r5}                   // and push it for the ret
    bl free                     // libc::free(old_head)
    b _popLeft_ret              // Done.

_popLeft_become_empty:
    ldr r0, [r5, #NODE_DATA_OFFSET] // retrieve data ptr
    push {r0}                   // push data ptr
    ldr r0, [r4, #HEAD_OFFSET]
    /* this also frees the tail. */
    bl free                     // libc::free(this->head)
    mov r0, #NULL
    str r0, [r4, #HEAD_OFFSET]  // clear head
    str r0, [r4, #TAIL_OFFSET]  // clear tail
    b _popLeft_ret

// return data and decrement counter
_popLeft_ret:
    ldr r0, [r4, #LEN_OFFSET]   // get the counter
    sub r0, #1                  // subtract one from it
    str r0, [r4, #LEN_OFFSET]   // and write it back
    // restore data ptr
    pop {r0}
    b _popLeft_ret_exit        // return data
// return without data (NULL)
_popLeft_ret_null:
    mov r0, #NULL
_popLeft_ret_exit:
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

/// Pops the tail node off the LL, and returns its data.
/// returns NULL if the LL is empty.
/// void* LinkedList_pop_right(LinkedList* this);
LinkedList_pop_right:
    push {r4-r8, r10,r11}
    push {lr}
    /* get the head and tail */
    ldr r5, [r4, #HEAD_OFFSET]  // load head node
    ldr r6, [r4, #TAIL_OFFSET]  // load tail

    /* first, check if the list is empty. */
    cmp r5, #NULL               // if (this->head == NULL) {
        beq _popLeft_ret_null   // return NULL
    // }


    /* check if the head is the tail */
    cmp r5, r6  // if (this->head == this->tail)) {
        // because if it is, it becomes empty, reuse logic.
        beq _popLeft_become_empty   // return _popLeft_become_empty()
    // }
    /* it is not, do this the hard way... */

    /* step 1: retrieve data ptr */
    ldr r7, [r6, #NODE_DATA_OFFSET] // retrieve data
    push {r7}                       // and push it for later retrieval.
    push {r6}                       // preserve old_tail ptr
    /* step 2: get new tail ptr */
    ldr r6, [r6, #NODE_PREVIOUS_OFFSET] // r6:= new_tail = old_tail->prev
    mov r7, #NULL
    /* step 3: update new tail ptr's next and LL's tail */
    str r7, [r6, #NODE_NEXT_OFFSET] // new_tail->next = NULL
    str r6, [r4, #TAIL_OFFSET]      // this->tail = new_tail

    /* step 4: purge old node */
    pop {r0}                        // pop old tail ptr
    bl free                         // libc::free(old_tail)

    /* decrement counter */
    ldr r0, [r4, #LEN_OFFSET]   // get the counter
    sub r0, #1                  // subtract one from it
    str r0, [r4, #LEN_OFFSET]   // and write it back
    pop {r0}                        // restore data ptr
_pop_right_ret:
    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr                       // do actually return here ;)

/// Pops element N from the LL, should it exist.
/// returns the data at that node, should it exist, otherwise NULL.
/// void* LinkedList_pop_n(LinkedList *this, uint32_t n);
LinkedList_pop_n:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0                  // Preserve this.

    /* precondition: n==0 -> pop head */

    cmp r1, #0                  // if (n == 0) {
        // void* LinkedList_pop_left(LinkedList* this);
        beq _pop_n_pop_left     // Same as popping the leftmost node.
    // }

    /* precondition: n== len(this) -> pop tail */

    // uint32_t LinkedList_len(LinkedList* this) const;
    bl LinkedList_len           // r0 := this->len()
    sub r0, #1                  // len -= 1
    cmp r0, r1                  // if (this->len()-1 == n) {
        beq _pop_n_pop_right    //      return _pop_n_pop_right()

    /* precondition: n > len -> return null */

    // } else if (this->len < n) {
        blt _pop_n_pop_null     // return null
    // }

    /* general case */
    cpy r0, r4                  // restore this
    /* fetch the node and perform a sanity check */

    // Node *LinkedList_get_nth(LinkedList* this, n: int) const;
    bl LinkedList_get_nth       // r0 := node = LinkedList_get_nth(this)
    cmp r0, #NULL               // if (node == NULL) {
        beq _pop_n_ret          // return NULL
    // }
    /* cache data */
    ldr r1, [r0, #NODE_DATA_OFFSET] // load node data
    push {r1}                       // push data since i pop it later...
    push {r0}                       // cache node for later.
    /* acquire effected nodes. Note: both nodes will not be null at this point. */
    ldr r5, [r0, #NODE_NEXT_OFFSET]     // r5 := next
    ldr r6, [r0, #NODE_PREVIOUS_OFFSET] // r6 := previous
    str r5, [r6, #NODE_NEXT_OFFSET]     // update previous->next=next
    str r6, [r5, #NODE_PREVIOUS_OFFSET] // update next->previous=previous

    /* finally free the old node */
    pop {r0}
    bl free                             // free(old_node)
    /* and decrement counter */
    ldr r0, [r4, #LEN_OFFSET]   // get the counter
    sub r0, #1                  // subtract one from it
    str r0, [r4, #LEN_OFFSET]   // and write it back

    pop {r0}
    b _pop_n_ret

/* it occured to me the CPSR wouldn't be safe across function calls, so do this as a
 * subroutine so the CPSR becomes irrelevant.
 */
_pop_n_pop_left:
        bl LinkedList_pop_left  // this->LinkedList_pop_left()
        b _pop_n_ret            // return
_pop_n_pop_right:
        bl LinkedList_pop_right // this->LinkedList_pop_right()
        b _pop_n_ret            // return

_pop_n_pop_null:
        mov r0, #NULL           // return NULL
        b _pop_n_ret            // return

_pop_n_ret:

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr





    .end


