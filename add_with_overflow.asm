# Demo Program That Will Trigger Custom Interrupt When Adding Two Numbers Results In
# An Overflow

.data 
prompt: .asciiz "Enter a number:   "
result: .asciiz "The sum is:   "
overflow_message: .asciiz "Overflow warning... don't trust the result\n"
other_message: .asciiz "Some other error occurred.\n"

.text 
# Read first number
li $v0, 4
la $a0, prompt 
syscall
li $v0, 5 
syscall
move $t0, $v0

# Read second number
li $v0, 4
la $a0, prompt 
syscall
li $v0, 5 
syscall
move $t1, $v0

li $t2, 5
div $t2, $t2, $zero

add $t2, $t0, $t1

# Print out the sum
li $v0, 4
la $a0, result 
syscall
li $v0, 1 
move $a0, $t2
syscall

# Terminate program
li $v0, 10
syscall

# use the following memory to save any important registers during interrupt handling
.kdata
saved_registers: .space 8

# start of interrupt handler
.ktext 0x80000180
move $k1, $at		# save the $at register in case interrupt happens during macro instruction
# Save important registers to the kdata memory
la $a2, saved_registers
sw $t0, ($a2)
sw $t1, 4($a2)
# Obtain the cause of the exception
mfc0 $k0, $13	   	# register $13 is the cause register in co-processor 0
srl $k0, $k0, 2		# shift cause bits to the right by 2 bits
andi $t0, $k0, 0xF	# isolate the cause bits

# Print out error message that depends on whether it is overflow or not
bne $t0, 12, other_exception
la $a0, overflow_message
b done
other_exception:
la $a0, other_message 
done:
li $v0, 4 
syscall

# recover from the interrupt
# make sure we return to the instruction after the offending instruction
mfc0 $k0, $14
addi $k0, $k0, 4
mtc0 $k0, $14
# clean up the status register
mfc0 $k0, $12
andi $k0, $k0, 0xFFFD	# clear the interrupt bit
ori $k0, $k0, 1			# set the enable bit
mtc0 $k0, $12
# clean up the cause register
mtc0 $zero, $13
# restore the state
lw $t0, ($a2)
lw $t1, 4($a2)
move $at, $k1
# return 
eret
