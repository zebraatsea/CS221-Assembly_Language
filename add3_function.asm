#Demo program that calls a function which adds its three
#arguments and returns a sum.

.data
   input_prompt: .asciiz "Enter a number:  "
   output_prompt: .asciiz "The sum is:  "
   
.text
main:
#grab first num
li $v0, 4
la $a0, input_prompt
syscall
li $v0, 5
syscall
move $t1, $v0

#grab second num
li $v0, 4
la $a0, input_prompt
syscall
li $v0, 5
syscall
move $t2, $v0

#grab third num
li $v0, 4
la $a0, input_prompt
syscall
li $v0, 5
syscall
move $t3, $v0

# code that calls the function using call stack
### Step 1: Allocate stack space
addiu $sp, $sp, -20
### Step 2: Write input params and impt registers to stack
sw $t1, 0($sp)
sw $t2, 4($sp)
sw $t3, 8($sp)
			#resrve 4 byts for return val
sw $ra, 16($sp)
### Step 3: Call function
jal add3
### Step 4: Read reurned values and restor impt regs from stack
lw $ra, 16($sp)
lw $t0, 12($sp)
### Step 5: Deallocate stack space
addiu $sp, $sp, 20

# print out resutlt (in $t0)
li $v0, 4
la $a0, output_prompt
syscall
li $v0, 1
move $a0, $t0
syscall

# termincate
li $v0, 10
syscall

# FUNCTION
add3:
### Step A: Reads args from stack
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
### Step B: Business logic
add $t0, $a0, $a1
add $t0, $t0, $a2
### Step C: Write return val(s) to stack
sw $t0, 12($sp)
### Step D: Return to caller
jr $ra