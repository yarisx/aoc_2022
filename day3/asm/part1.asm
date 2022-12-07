.global _check_line
.p2align 2


_check_line:
        // x0 - pointer to the string to check
        // x1 - (strlen / 2)
        adrp x2, bitmap@PAGE
        add x2, x2, bitmap@PAGEOFF
        mov x3, #0      // char index
        str x3, [x2]    // zero-out bitmap
loop:
        ldrb w4, [x0, x3]    // get the next char from the input string
        add x3, x3, #1      // analog of 'i++'
        // mov x6, x4          // dbg - store the original character
        cmp w4, #0          //
        b.eq return         // if zero - it's end of line, return
        cmp w4, #'Z'        // else
        b.le upper          // convert to 'value'
        sub w4, w4, #96     // lowercase
        b set
upper:
        sub w4, w4, #38     // uppercase
set:
        mov x7, #1
        lsl x7, x7, x4      // prepare bitmask
        ldr x5, [x2]       // load value from the 'counter'
        cmp x3, x1          // if have not reached the middle
        b.le addset         //     increase the counter
        and x5, x5, x7
        cmp x5, #0          // else if counter is non-zero
        b.ne return         //     return the 'value'
        b incloop           // increase the counter, loop
addset:
        orr x5, x5, x7      // set the flag
        str x5, [x2]
incloop:
        b loop
return:
        mov x0, x4
        ret

.data
bitmap: .fill 8, 1, 0
