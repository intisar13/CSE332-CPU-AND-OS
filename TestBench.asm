.data
msg:        .asciiz "Hello, World!"  # String to print
result1:    .asciiz "Result of $4: "  # Message for $4
result2:    .asciiz "Result of $5: "  # Message for $5
result3:    .asciiz "Result of $6: "  # Message for $6
result4:    .asciiz "Result of $7: "  # Message for $7
result5:    .asciiz "Result of $8: "  # Message for $8
result6:    .asciiz "Result of $9: "  # Message for $9
result7:    .asciiz "Result of $10: " # Message for $10
result8:    .asciiz "Result of $11: " # Message for $11
result9:    .asciiz "Result of $12: " # Message for $12
result10:   .asciiz "Result of $13: " # Message for $13
value14:    .asciiz "Value in $14: "  # Message for $14
value15:    .asciiz "Value in $15: "  # Message for $15
value16:    .asciiz "Value in $16: "  # Message for $16
value17:    .asciiz "Value loaded in $17: "  # Message for $17

.text
main:
    # Initialize register $4 with the value 27
    addi $4, $0, 27      # $4 = 27

    # Perform bitwise XOR between $4 and 5, store result in $5
    xori $5, $4, 5       # $5 = $4 ^ 5

    # Add the values in $4 and $5, store the result in $6
    add $6, $4, $5       # $6 = $4 + $5

    # Subtract $4 from $5, store the result in $7
    sub $7, $5, $4       # $7 = $5 - $4

    # Set $8 to 1 if $7 is less than $6, else set $8 to 0
    slt $8, $7, $6       # $8 = ($7 < $6) ? 1 : 0

    # Perform bitwise OR between $7 and $0, store result in $9
    or $9, $7, $0        # $9 = $7 | $0 (effectively $9 = $7)

    # Perform bitwise AND between $7 and $0, store result in $10
    and $10, $7, $0      # $10 = $7 & $0 (effectively $10 = 0)

    # Shift $7 left by 1 bit, store result in $11
    sll $11, $7, 1       # $11 = $7 << 1

    # Shift $7 right by 1 bit, store result in $12
    srl $12, $7, 1       # $12 = $7 >> 1

    # Set $13 to 1 if $8 is less than $7, else set $13 to 0
    slt $13, $8, $7      # $13 = ($8 < $7) ? 1 : 0

    # Load immediate value 12 into register $14
    li $14, 12           # $14 = 12

    # Load immediate value 110 into register $15
    li $15, 110          # $15 = 110

    # Load immediate value 120 into register $16
    li $16, 120          # $16 = 120

    # Store the value in $15 at the address ($14 + 4)
    sw $15, 4($14)       # Memory[$14 + 4] = $15

    # Store the value in $16 at the address ($14 + 8)
    sw $16, 8($14)       # Memory[$14 + 8] = $16

    # Load the word from the address ($14 + 4) into register $17
    lw $17, 4($14)       # $17 = Memory[$14 + 4]

    # ```assembly
    # Print results
    # Print result of $4
    li $v0, 4            # syscall for print_string
    la $a0, result1      # load address of result1
    syscall               # make syscall

    move $a0, $4         # move value of $4 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $5
    li $v0, 4            # syscall for print_string
    la $a0, result2      # load address of result2
    syscall               # make syscall

    move $a0, $5         # move value of $5 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $6
    li $v0, 4            # syscall for print_string
    la $a0, result3      # load address of result3
    syscall               # make syscall

    move $a0, $6         # move value of $6 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $7
    li $v0, 4            # syscall for print_string
    la $a0, result4      # load address of result4
    syscall               # make syscall

    move $a0, $7         # move value of $7 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $8
    li $v0, 4            # syscall for print_string
    la $a0, result5      # load address of result5
    syscall               # make syscall

    move $a0, $8         # move value of $8 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $9
    li $v0, 4            # syscall for print_string
    la $a0, result6      # load address of result6
    syscall               # make syscall

    move $a0, $9         # move value of $9 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $10
    li $v0, 4            # syscall for print_string
    la $a0, result7      # load address of result7
    syscall               # make syscall

    move $a0, $10        # move value of $10 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $11
    li $v0, 4            # syscall for print_string
    la $a0, result8      # load address of result8
    syscall               # make syscall

    move $a0, $11        # move value of $11 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $12
    li $v0, 4            # syscall for print_string
    la $a0, result9      # load address of result9
    syscall               # make syscall

    move $a0, $12        # move value of $12 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print result of $13
    li $v0, 4            # syscall for print_string
    la $a0, result10     # load address of result10
    syscall               # make syscall

    move $a0, $13        # move value of $13 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print value in $14
    li $v0, 4            # syscall for print_string
    la $a0, value14      # load address of value14
    syscall               # make syscall

    move $a0, $14        # move value of $14 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print value in $15
    li $v0, 4            # syscall for print_string
    la $a0, value15      # load address of value15
    syscall               # make syscall

    move $a0, $15        # move value of $15 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print value in $16
    li $v0, 4            # syscall for print_string
    la $a0, value16      # load address of value16
    syscall               # make syscall

    move $a0, $16        # move value of $16 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Print value loaded in $17
    li $v0, 4            # syscall for print_string
    la $a0, value17      # load address of value17
    syscall               # make syscall

    move $a0, $17        # move value of $17 to $a0
    li $v0, 1            # syscall for print_int
    syscall               # make syscall

    # Exit the program
    li $v0, 10           # syscall for exit
    syscall               # make syscall