.global _list_sum
.global _total_sum
.p2align 2

_list_sum:
        mov x2, x0 // pointer to the first array element
        lsl x3, x1, #2 // array length in bytes (assuming incoming type is int32)
        mov w4, #0 // Initial sum
loop_start:
        cmp x3, #0
        b.eq return
        sub x3, x3, #4
        ldr w5, [x2, x3]
        add w4, w4, w5
        b loop_start
return:
        mov x0, #0
        mov w0, w4
        ret

_total_sum: // x0 - input array (of int32)
            // x1 - length of the input array (elements)
            // x2 - array of sums (of int32)
            // x3 - length of the array of sums (elements)

        lsl x1, x1, #2  // length of input array in bytes
        mov x4, #0      // i = 0
        lsl x3, x3, #2  // length of output array in bytes
        mov x5, #0      // j = 0
loop_start_b:
        mov w6, #0  // sum
loop_start_s:
        cmp x4, x1
        b.eq return_tot_sum
        ldr w7, [x0, x4]
        add x4, x4, #4
        cmp w7, 0
        b.eq next_array
        add w6, w6, w7
        b loop_start_s
next_array:
        str w6, [x2, x5]
        add x5, x5, #4
        b loop_start_b
return_tot_sum:
        ret
