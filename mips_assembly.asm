# MIPS Assembly: Find MAX, MIN, MEAN from an array of integers

.text
.globl main

# Main Function
main:
    # Load numbers into memory
    li $t0, 0x10010000    # Base address for memory storage (starting address for array)
    
    li $t1, 10            # Number of elements (array length)
    sw $t1, 0($t0)        # Store number of elements at base address (0x10010000)
    
    li $t1, 10            # First number
    sw $t1, 4($t0)        # Store first number at 4($t0)
    li $t1, 12            # Second number
    sw $t1, 8($t0)        # Store second number at 8($t0)
    li $t1, 7             # Third number
    sw $t1, 12($t0)       # Store third number at 12($t0)
    li $t1, 3             # Fourth number
    sw $t1, 16($t0)       # Store fourth number at 16($t0)
    li $t1, 19            # Fifth number
    sw $t1, 20($t0)       # Store fifth number at 20($t0)
    li $t1, 8             # Sixth number
    sw $t1, 24($t0)       # Store sixth number at 24($t0)
    li $t1, 11            # Seventh number
    sw $t1, 28($t0)       # Store seventh number at 28($t0)
    li $t1, 15            # Eighth number
    sw $t1, 32($t0)       # Store eighth number at 32($t0)
    li $t1, 6             # Ninth number
    sw $t1, 36($t0)       # Store ninth number at 36($t0)
    li $t1, 2             # Tenth number
    sw $t1, 40($t0)       # Store tenth number at 40($t0)

    # Call MAX function
    la $a0, 0($t0)        # Load base address of the array (array starting address)
    lw $a1, 0($a0)        # Load array length into $a1
    jal find_max

    # Store result of MAX in $s0
    move $s0, $v0    

    # Call MIN function
    la $a0, 0($t0)        # Load base address of the array
    lw $a1, 0($a0)        # Load array length into $a1
    jal find_min

    # Store result of MIN in $s1
    move $s1, $v0    

    # Call MEAN function
    la $a0, 0($t0)        # Load base address of the array
    lw $a1, 0($a0)        # Load array length into $a1
    jal find_mean

    # Store result of MEAN in $s2
    move $s2, $v0    

    # Exit program
    li $v0, 10            # Exit syscall
    syscall

# Function: find_max
find_max:
    lw $t0, 4($a0)        # Load first element into $t0 (skip the first 4 bytes for length)
    move $t1, $a1         # Counter in $t1

max_loop:
    beq $t1, 0, max_done  # Exit loop when counter reaches 0
    lw $t2, 4($a0)        # Load current element into $t2
    addi $a0, $a0, 4      # Move to the next element in the array
    addi $t1, $t1, -1     # Decrement counter
    blt $t0, $t2, update_max
    j max_loop

update_max:
    move $t0, $t2         # Update max value
    j max_loop

max_done:
    move $v0, $t0         # Return max value in $v0
    jr $ra                # Return to caller

# Function: find_min
find_min:
    lw $t0, 4($a0)        # Load first element into $t0 (skip the first 4 bytes for length)
    move $t1, $a1         # Counter in $t1

min_loop:
    beq $t1, 0, min_done  # Exit loop when counter reaches 0
    lw $t2, 4($a0)        # Load current element into $t2
    addi $a0, $a0, 4      # Move to the next element in the array
    addi $t1, $t1, -1     # Decrement counter
    bgt $t0, $t2, update_min
    j min_loop

update_min:
    move $t0, $t2         # Update min value
    j min_loop

min_done:
    move $v0, $t0         # Return min value in $v0
    jr $ra                # Return to caller

# Function: find_mean
find_mean:
    move $t0, $zero       # Sum accumulator
    move $t1, $a1         # Counter in $t1
    move $t2, $a1         # Store original count for division

mean_loop:
    beq $t1, 0, mean_sum_done  # Exit loop when counter reaches 0
    lw $t3, 4($a0)        # Load current element into $t3
    add $t0, $t0, $t3     # Add to sum
    addi $a0, $a0, 4      # Move to next element
    addi $t1, $t1, -1     # Decrement counter
    j mean_loop

mean_sum_done:
    # Division: $t0 (sum) / $t2 (count)
    move $a0, $t0         # Dividend in $a0
    move $a1, $t2         # Divisor in $a1
    jal divide            # Call divide subroutine
    move $v0, $v0         # Result in $v0
    jr $ra                # Return to caller

# Subroutine: divide
divide:
    move $t0, $zero       # Initialize quotient
    move $t1, $a0         # Copy dividend
    move $t2, $a1         # Copy divisor

divide_loop:
    blt $t1, $t2, divide_done  # Exit if dividend < divisor
    sub $t1, $t1, $t2          # Subtract divisor from dividend
    addi $t0, $t0, 1           # Increment quotient
    j divide_loop

divide_done:
    move $v0, $t0             # Return quotient in $v0
    jr $ra                    # Return to caller