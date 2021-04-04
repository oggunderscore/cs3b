.data
mallinfo_struct:    .space 40

.text
.EQU uordblks_OFFSET, 28                        // 8th word. (8-1)*sizeof(int)
.global updateBytes
// void updateBytes();
// updates the allocated bytes counter
// by interrogating libc
updateBytes:
    push    {r4-r8, r10, r11}                   @ Push preserved registers

    push    {lr}                                // Push linked register
    /* step one: retrieve the mallinfo struct for the default arena
     * As this is a single-thread assembly program.
     * only one arena exists: the default one.
     * this this call suffices to answer the posed question.
     */

    # bl malloc_stats
    /* by AAPCS, since libc::mallinfo returns a composite type > 4 bytes,
     * it MUST be passed a suitable buffer in r0
     */
    ldr r0, =mallinfo_struct                    // load pointer in r0 to a suitable buffer
    /* this func returns malloc info for the default arena */
    bl mallinfo                                 // libc::mallinfo()
    /* we only care about mallinfo->uordblks, aka total allocated bytes */
    ldr r1, [r0, #uordblks_OFFSET]              // load allocated bytes to r1
    ldr r0, =numBytes                           // retrieve pointer to storage
    str r1, [r0]                                // store allocated bytes to storage

    pop     {lr}                                // restore LR
    pop     {r4-r8, r10, r11}                   // pop preserved registers
    bx      lr
.end
