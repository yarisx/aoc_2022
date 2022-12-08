.global _sop_mark

.p2align 2

_sop_mark:
    stp lr, fp, [sp, #-16]!
    // x0 is pointer to the string
    // x1 is the string length
    adrp x2, counters@PAGE
    add  x2, x2, counters@PAGEOFF
    // x17 is helper
    mov x6, x0
    mov x7, x1
    mov x10, #0  // the marker place

    bl _prefill
    // w4 is the pre-filled register with 4 chars
    // x3 is 4 (the next offset to read from)
    // x2 is set with bits
_loop_sop_mark:
    cmp x10, x7
    b.eq _bad_end_sop_mark
    bl _bitcount
    cmp w0, #4      // if 4 then all chars are different - exit
    b.eq _end_sop_mark

    lsr w0, w4, #24 // remove bit of the falling-off character
    bl _del_bit
    lsl w4, w4, #8      // fall off
    ldrb w0, [x6, x10]   // read the next character
    cmp w0, #'\n'
    b.eq _bad_end_sop_mark
    add x10, x10, #1      //
    orr w4, w4, w0      // add it to the 'marker' register
    bl _add_bit         // set the appropriate bit
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
    // x0 is the char, x2 is the bitset to add to
    stp lr, fp, [sp, #-16]!
    sub x0, x0, #'a'
    ldrb w17, [x2, x0]
    add w17, w17, #1
    strb w17, [x2, x0]
    ldp lr, fp, [sp], #16
    ret

_del_bit:
    // x0 is the char, x2 is the bitset to add to
    stp lr, fp, [sp, #-16]!
    sub x0, x0, #'a'
    ldrb w17, [x2, x0]
    sub w17, w17, #1
    strb w17, [x2, x0]
    ldp lr, fp, [sp], #16
    ret

_prefill:
    // x6 is global pointer to the string
    // x1 is (unused) length of the string
    stp lr, fp, [sp, #-16]!
    mov w4, #0      // init the 'window'
    ldrb w3, [x6, #0]
    mov x0, x3
    bl _add_bit
    lsl w3, w3, #24
    orr w4, w4, w3
    ldrb w3, [x6, #1]
    mov x0, x3
    bl _add_bit
    lsl w3, w3, #16
    orr w4, w4, w3
    ldrb w3, [x6, #2]
    mov x0, x3
    bl _add_bit
    lsl w3, w3, #8
    orr w4, w4, w3
    ldrb w3, [x6, #3]
    mov x0, x3
    bl _add_bit
    orr w4, w4, w3
    mov x10, 4
    ldp lr, fp, [sp], #16
    ret

_get_value:
    // x0 is the char
    ret
    mov x0, #32
    ret

_bitcount:
    // w2 is the global value to count bits in, supposed to be 32-bit wide
    stp lr, fp, [sp, #-16]!
    mov w11, #0      // This is counter
    mov w12, #0      // This is i
_bitloop:
    cmp w12, #32     // if i == 32 return
    b.eq _bitloop_end
    ldrb w13, [x2, x12]
    add w12, w12, #1      // i++
    cmp w13, #0
    b.eq _bitloop
    add w11, w11, #1      // ...then counter++
    b _bitloop
_bitloop_end:
    mov x0, x11
    ldp lr, fp, [sp], #16
    ret

.data
counters: .fill 32, 8, 0
