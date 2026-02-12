# Function to determine if the value in its input argument is divisible by 9
main:
# Test cases
	li a0, 81   # Test case 1: 15 is divisible by 9
	jal div9    # Call the function
    
	#li a0, 81   # Test case 2: 81 is divisible by 9
	#jal div9    # Call the function
div9:
    # Save the value of a0 to t0 for later use
    mv t0, a0
    # Initialize t1 to store the remainder
    li t1, 0
    
    # Loop to subtract 9 from t0 until it becomes negative or zero
loop:
    li t1, 9
    sub t0, t0, t1
    # Check if t0 is negative
    beq t0, zero, divisible_by_9
    
    blt t0, zero, not_divisible_by_9
    # If t0 is still positive, update the remainder in t1 and repeat the loop
    addi t1, t1, 1
    j loop

# Label to set a0 to 1 when it is divisible by 9
divisible_by_9:
    # Set a0 to 1
    li a0, 1
    j exit

# Label to set a0 to 0 when it is not divisible by 9
not_divisible_by_9:
    # Set a0 to 0
    li a0, 0
    j exit

# Label to exit the function
exit:
    # Return to the calling function using jr ra
    j exit
