main:
  # Load the source and target addresses into registers
  li t0, 0x300
  li t1, 0x400

  # Load the number of words to convert into a register
  li t2, 8

convert_loop:
  # Load one word from the source memory (big-endian) into t3
  lw t3, 0(t0)

  # Swap the byte order (convert to little-endian) and store in target memory
  # Load the bytes using lb and store them in the reversed order using sb
  lb t4, 0(t3)   # Load byte 0 (MSB) from t3
  sb t4, 3(t1)   # Store byte 0 (MSB) to t1 (address + 3)

  lb t4, 1(t3)   # Load byte 1 from t3
  sb t4, 2(t1)   # Store byte 1 to t1 (address + 2)

  lb t4, 2(t3)   # Load byte 2 from t3
  sb t4, 1(t1)   # Store byte 2 to t1 (address + 1)

  lb t4, 3(t3)   # Load byte 3 (LSB) from t3
  sb t4, 0(t1)   # Store byte 3 (LSB) to t1 (address + 0)

  # Move to the next word in both source and target memory
  addi t0, t0, 4  # Increment source address by 4 (word size)
  addi t1, t1, 4  # Increment target address by 4 (word size)

  # Decrement the word counter
  addi t2, t2, -1
  bnez t2, convert_loop  # If t2 != 0, repeat the loop

