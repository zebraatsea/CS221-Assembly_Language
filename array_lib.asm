# Array Library
.data
delimiter: .asciiz ", "

.text
# Function that prints out an array
.globl print_array
print_array:
    # Step A: Read args from the stack
    lw $a1, 0($sp)      # read array address
    lw $s0, 4($sp)      # read array size
    # Step B: Business logic
    print_loop:
        blez $s0, print_done
        lw $a0, ($a1)   # read next array element
        li $v0, 1
        syscall         # print out the next integer
        addi $a1, $a1, 4    # move to next array element
        addi $s0, $s0, -1   # decrement loop counter
        # delimiter logic here
        blez $s0, delimiter_done
            la $a0, delimiter
            li $v0, 4
            syscall
        delimiter_done:
        b print_loop
    print_done:
    # Step C: Write return values to the stack
    ### Nothing to do... no return value ###
    # Step D: Return to caller
    jr $ra

# Function that returns the sum of an array
.globl array_sum
array_sum:
    # Step A: Read the args from stack
    lw $a0, 0($sp)      # read array address
    lw $s0, 4($sp)      # read array size
    # Step B: Business logic
    li $t0, 0
    sum_loop:
        blez $s0, sum_loop_done     # exit loop if no 
                                    # more element are left
        lw $t1, ($a0)               # read next array value
        add $t0, $t0, $t1           # increment accumulator
        addi $a0, $a0, 4            # move to next array element
        addi $s0, $s0, -1           # decrement loop counter
        b sum_loop
    sum_loop_done:
    # Step C: Write return value to stack
    sw $t0, 8($sp)      # write return value
    # Step D: Return to caller
    jr $ra

# Private/non-global helper function for calculating the max of two integers
integer_max:
    # Step A: Read the args from stack
    lw $t1, 0($sp)      # arg 1
    lw $t2, 4($sp)      # arg 2
    # Step B: Business Logic
    # Use if/else to set $t0 equal to the max of $t1 and $t2
    bgt $t2, $t1, max_else
        move $t0, $t1   # put $t1 into $t0 if $t2 <= $t1
        b max_done
    max_else:
        move $t0, $t2   # put $t2 into $t0 if $t2 > $t1
    max_done:
    # Step C: Write return value to stack
    sw $t0, 8($sp)
    # Step D: Return to caller
    jr $ra

# Function that returns the pairwise max of two arrays
.globl pairwise_max
pairwise_max:
    # Step A: Read args from stack
    lw $a1, 0($sp)      # first input array address
    lw $a2, 4($sp)      # second input array address
    lw $a0, 8($sp)      # output array address
    lw $t0, 12($sp)     # array size
    # Step B: Business logic
    # Step C: Write return value to stack
    # Step D: Return to caller
    pairwise_max_loop:
        # exit loop if there are no more array elements
        blez $t0, pairwise_max_done
        # read the next pair of elements from the input arrays
        lw $s1, ($a1)
        lw $s2, ($a2)
        # calculate the maximum of $s1 and $s2 and put result in $s0
        # via nested function call into integer_max function
        
        # Step 1: Allocate stack space
        addiu $sp, $sp, -20
        # Step 2: Write input args and important registers to stack
        sw $s1, 0($sp)
        sw $s2, 4($sp)
        sw $ra, 12($sp)
        sw $t0, 16($sp)
        # Step 3: Call the function
        jal integer_max
        # Step 4: Read return value and restore important registers from stack
        lw $t0, 16($sp)
        lw $ra, 12($sp)
        lw $s0, 8($sp)  # max of the two elements
        # Step 5: Deallocate stack space.
        addiu $sp, $sp, 20

        # write pairwise max into the output array
        sw $s0, ($a0)
        # increment my loop counters
        addi $a0, $a0, 4
        addi $a1, $a1, 4
        addi $a2, $a2, 4
        addi $t0, $t0, -1
        b pairwise_max_loop
    pairwise_max_done:
    jr $ra