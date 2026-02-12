sortarray:  .word 89, 63, -55, -107, 42, 98, -425, 203, 0, 303
main:
    # Initialize pointers
    la t0, sortarray # t0 = &sortarray[0]
    li t1, 10         # t1 = n (number of elements in the array)
	li t4, 1
    li t5, 10
    # Outer loop (for i = 0; i < n - 1; i++)
    li t2, 0         # t2 = i (initialize i to 0)
outer_loop:
    bge t2, t1, exit_outer_loop   # if i >= n, exit the loop

    # Inner loop (for j = 0; j < n - i - 1; j to 0)
inner_loop:
    bge t3, t1, exit_inner_loop   # if j >= n, exit the loop

    # Load elements to compare: sortarray[j] and sortarray[j + 1]
    lw s0, 0(t0)     # s0 = sortarray[j]
    lw s1, 4(t0)     # s1 = sortarray[j + 1]

    # Compare elements and swap if needed
    bge s0, s1, no_swap
    # Swap elements
    sw s0, 4(t0)     # sortarray[j] = s1
    sw s1, 0(t0)     # sortarray[j + 1] = s0
    li t6, 1         # Set t6 to 1 to indicate a swap
    j continue_inner_loop
no_swap:
    li t6, 0         # Set t6 to 0 to indicate no swap
continue_inner_loop:
    addi t3, t3, 1   # Increment j
    addi t0, t0, 4   # Increment the array pointer
    # Repeat the inner loop
    j inner_loop
exit_inner_loop:
    # If t6 == 0, no swap occurred, and the array is sorted. Exit the outer loop.
    beqz t6, exit_outer_loop

    addi t2, t2, 1   # Increment i
    li t6, 0         # Reset t6 to 0 for the next iteration of the outer loop
    la t0, sortarray # Reset the array pointer to the beginning
    sub t1, t1, t4    # Decrement n for the next iteration of the outer loop
    # Repeat the outer loop
    j outer_loop
exit_outer_loop:

    ecall 