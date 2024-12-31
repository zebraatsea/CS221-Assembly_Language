#Program that calls the add3 funtion

.data


.text
main:

li $t0, 1
li $t1, 2
li $t2, 3

# Step 1: Allocate stack space
addiu $sp, $sp, -20
# Step 2: Write input params and impt registers to stack
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
#return val = 12($sp)
sw $ra, 16($sp)
# Step 3: Call function
jal add3
# Step 4: Read reurned values and restor impt regs from stack
lw $t3, 12($sp)
lw $ra, 16($sp)
# Step 5: Deallocate stack space
addiu $sp, $sp, 20

# Terminate program
li $v0, 10
syscall


###FUNCTION ADD3
add3:
# Step A: Reads args from stack
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
# Step B: Business logic
add $t0, $a0, $a1
add $t0, $t0, $a2
# Step C: Write return val(s) to stack
sw $t0, 12($sp)
# Step D: Return to caller
jr $ra