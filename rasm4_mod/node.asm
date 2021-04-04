    .data
// the size, in bytes, of an individual Node.
.equ NODE_SIZE, 12
// Size of an individual word
.equ WORD_SIZE, 4
// Number of elements in the Node struct
.equ NODE_ELEM_LEN, 3
.equ NODE_DATA_OFFSET, 0
.equ NODE_NEXT_OFFSET, 4
.equ NODE_PREVIOUS_OFFSET, 8

    .text
    .global Node
    .global getNodeData
    .global getNodeNext
    .global getNodePrevious
    .global setNodePrevious
    .global setNodeNext
    .global setNodeData


/*
struct Node {
 char *data
 Node *next
 Node *previous
 }
*/

// Allocates a new node, populating it with arg data
// Node* Node(void *data);
Node:
    push {r4-r8, r10,r11}
    push {lr}
    cpy r4, r0              // preserve data ptr
    //        void *calloc(size_t nmemb, size_t size);
    ldr r0, =NODE_ELEM_LEN  // number of elements in a Node
    ldr r1, =WORD_SIZE      // each element is the size of a word
    bl calloc               // return libc::calloc(NODE_ELEM_LEN, WORD_SIZE);
    stm r0, {r4}          // store data ptr into newly allocated block at correct place

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// Returns this->data
// *Node getNodeData(Node *this)
getNodeData:
    push {r4-r8, r10,r11}
    push {lr}

    ldm r0, {r4,r5,r6}
    cpy r0, r4

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr
// Returns this->next
// *Node getNodeNext(Node *next)
getNodeNext:
    push {r4-r8, r10,r11}
    push {lr}

    ldm r0, {r4,r5,r6}
    cpy r0, r5

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr
// Returns this->previous
// *Node getNodePrevious(Node *this)
getNodePrevious:
    push {r4-r8, r10,r11}
    push {lr}

    ldm r0, {r4,r5,r6}
    cpy r0, r6

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// void setNodePrevious(Node *this, Node *previous)
setNodePrevious:
    push {r4-r8, r10,r11}
    push {lr}

    ldm r0, {r4,r5,r6}
    cpy r6, r1

    stm r0, {r4,r5,r6}

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr



// void setNodeNext(Node *this, Node *next)
setNodeNext:
    push {r4-r8, r10,r11}
    push {lr}

    ldm r0, {r4,r5,r6}
    cpy r5, r1

    stm r0, {r4,r5,r6}

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr

// void setNodeData(Node *this, void *data)
setNodeData:
    push {r4-r8, r10,r11}
    push {lr}

    ldm r0, {r4,r5,r6}
    cpy r4, r1

    stm r0, {r4,r5,r6}

    pop {lr}
    pop {r4-r8, r10,r11}
    bx lr
