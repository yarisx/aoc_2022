.global _elvproc2

.p2align    2

_elvproc2:
    stp lr, fp, [sp, #-16]!
    // x0 address of the input array of additions (int8)
    // x1 length of the array
    // x2 address of the results array (size of input) (int8)
    // (unused) x3 length of the results array

    // x4 global input counter
    // x5 global accumulator
    // x9 wrapped sprite position
    // x10 res counter in bytes
    mov x4, #0
    mov x5, #1
    mov x9, #0      // wrapped position
    mov x10, #0
_elvproc_loop:
    cmp x4, x1
    b.eq _elvproc_end

    mov x7, x5
    cmp x7, x9
    b.eq _elvproc_vis
    sub x7, x7, #1
    cmp x7, x9
    b.eq _elvproc_vis
    add x7, x7, #2
    cmp x7, x9
    b.eq _elvproc_vis
    b _elvproc_nonvis
_elvproc_vis:
    mov x7, #1
    strb w7, [x2, x4]

_elvproc_nonvis:
    ldrb w6, [x0, x4]
    add x4, x4, #1
    add x5, x5, w6, sxtb

    add x9, x9, #1
    cmp x9, #40
    b.lt _elvproc_nowrap
    sub x9, x9, #40
_elvproc_nowrap:
    b _elvproc_loop

_elvproc_end:
    mov x0, #0
_elvproc_exit:
    ldp lr, fp, [sp], #16
    ret
