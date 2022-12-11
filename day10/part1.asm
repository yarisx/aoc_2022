.global _elvproc

.p2align    2

_elvproc:
    stp lr, fp, [sp, #-16]!
    // x0 address of the input array of additions
    // x1 length of the array
    // x2 address of the results array
    // x3 length of the results array

    // x4 global input counter
    // x5 global accumulator, starts with 1
    // x7 - tne next 'checkpoint'
    // x8 the global res counter (in units)
    // x9 helper
    // x10 res counter in bytes
    mov x4, #0
    mov x5, #1
    mov x7, #20
    mov x8, #0
    mov x10, #0
_elvproc_loop:
    cmp x4, x1
    b.eq _elvproc_end
    ldrb w6, [x0, x4]
    add x4, x4, #1
    cmp x4, x7          // Here the step number can be the "interesting" one,
                        // but the actual counter is not updated yet, as in "during" the step
    b.ne _elvproc_cont
_elvproc_mul:
    mul x9, x4, x5
    str w9, [x2, x10]
    add x10, x10, #4
    add x7, x7, #40
    cmp x7, #220
    b.gt _elvproc_end
_elvproc_cont:
    add x5, x5, w6, sxtb
    b _elvproc_loop

_elvproc_end:
    mov x0, #0
_elvproc_endloop:
    sub x10, x10, #4
    ldr w1, [x2, x10]
    add x0, x0, x1
    cmp x10, #0
    b.eq _elvproc_exit
    b _elvproc_endloop
_elvproc_exit:
    ldp lr, fp, [sp], #16
    ret
