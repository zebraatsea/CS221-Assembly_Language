# Program to calculate the maximus of two ints wihtout using branching logic

.data
input_prompt: .asciiz "Enter a number:   "
output_prompt: .asciiz "The max is:   "

.text
# Get the user inputs (into $t1 and $t2 respectively)
la $a0, input_prompt
li $v0, 4
syscall
li $v0, 5
syscall
move $t1, $v0

la $a0, input_prompt
li $v0, 4
syscall
li $v0, 5
syscall
move $t2, $v0

# Calculate the max
sub $t3, $t1, $t2	# $t3 = $t2 - $t1
sra $t3, $t3, 31	# $t3 = $t3 >> 31 (all 0's if $t1 >= $t2)
			# and all 1's if $t1 < $t2
not $t4, $t3		# $t4 is all 1's if 1 >= 2 and all 0's if 1 < 2

and $t5, $t1, $t4	# $t5 = $t1  if $t1 >= $t2 and 0 otherwise
and $t6, $t2, $t3	# $t6 = $t2 if $t2 > $t1 and 0 otherwise
add $t0, $t5, $t6

# Print the output and terminate
la $a0, output_prompt
li $v0, 4
syscall
li $v0, 1
move $a0, $t0
syscall
li $v0, 10
syscall
