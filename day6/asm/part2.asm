.global _sop_mark

.p2align 2

_sop_mark:
    stp lr, fp, [sp, #-16]!
    // x0 is pointer to the string
    // x1 is the string length
    // x2 is the address of counters for characters
    adrp x2, counters@PAGE
    add  x2, x2, counters@PAGEOFF
    // x3 is the address of the 'window' as it is 14 bytes -> no fit for register
    adrp x3, window@PAGE
    add x3, x3, window@PAGEOFF
    mov x6, x0
    mov x7, x1
    mov x8, #0      // index of the next place in the window (ring)
    mov x10, #0     // the marker place

    // in: x6 (global)
    // in: x3 (global)
    // out: x10 (global), x8 (global)
    // trash: x0, x4
    bl _prefill

_loop_sop_mark:
    cmp x10, x7
    b.eq _bad_end_sop_mark
    // in: x2 (global)
    // out: x0
    // trash: x11, x12, x13, x16 (via add_bit)
    bl _bitcount
    cmp w0, #14             // if 14 then all chars are different - exit
    b.eq _end_sop_mark

    mov x4, #0              // clean before read
    ldrb w4, [x3, x8]
    mov x0, x4
    // in: x0
    // trash: x16
    bl _del_bit
    ldrb w0, [x6, x10]      // read the next character
    cmp w0, #'\n'
    b.eq _bad_end_sop_mark
    add x10, x10, #1        //
    strb w0, [x3, x8]       //
    bl _add_bit             // set the appropriate bit
    add x8, x8, #1
    cmp x8, #14
    b.ne _loop_sop_mark
    mov x8, #0
    b _loop_sop_mark

    // here the loop should start
_end_sop_mark:
    mov x0, x10
    ldp lr, fp, [sp], #16
    ret
_bad_end_sop_mark:
    mov x0, #-1
    ldp lr, fp, [sp], #16
    ret

_add_bit:
    // x0 is the char, x2 is the counters address
    stp lr, fp, [sp, #-16]!
    sub x0, x0, #'a'
    ldrb w16, [x2, x0]
    add w16, w16, #1
    strb w16, [x2, x0]
    ldp lr, fp, [sp], #16
    ret

_del_bit:
    // x0 is the char, x2 is the counters address
    stp lr, fp, [sp, #-16]!
    sub x0, x0, #'a'
    ldrb w16, [x2, x0]
    sub w16, w16, #1
    strb w16, [x2, x0]
    ldp lr, fp, [sp], #16
    ret

_prefill:
    // x6 is global pointer to the string
    // x1 is (unused) length of the string
    stp lr, fp, [sp, #-16]!
    mov x10, #0
_prefill_loop:
    ldrb w4, [x6, x10]
    mov x0, x4
    bl _add_bit
    strb w4, [x3, x10]
    add x10, x10, 1
    cmp x10, #14
    b.ne _prefill_loop
    mov x8, #0
    ldp lr, fp, [sp], #16
    ret

_get_value:
    // x0 is the char
    ret
    mov x0, #32
    ret

_bitcount:
    stp lr, fp, [sp, #-16]!
    mov w11, #0             // This is counter
    mov w12, #0             // This is i
_bitloop:
    cmp w12, #32            // if i == 32 return
    b.eq _bitloop_end
    ldrb w13, [x2, x12]
    add w12, w12, #1        // i++
    cmp w13, #0
    b.eq _bitloop
    add w11, w11, #1        // ...then counter++
    b _bitloop
_bitloop_end:
    mov x0, x11
    ldp lr, fp, [sp], #16
    ret

.data
counters: .fill 32, 8, 0
window:   .fill 16, 1, 0
