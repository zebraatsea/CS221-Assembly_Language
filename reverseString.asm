#Program that asks a user to inpur a string and reverses it in place.
.data
input_prompt: .asciiz "Enter a string: "
output_prompt: .asciiz "Your reversed string: "
user_string: .space 24

.text
# Print out the input prompt
la $a0, input_prompt
li $v0, 4
syscall

# Ask user to input a string
la $a0, user_string
li $a1, 23	# max chars to read
li $v0, 8
syscall

# Iterate to find end of string and replace the newline char with
# null terminator, and then decrement by 1
move $a1, $a0		#copies string from $a0 to $a1
loop_find_end:
   lb $t0, ($a1)  		# read char from byte (into $t0, from string $a1)
   beq $t0, 10, end_found 	# if $t0 is newline char (10), leave loop
   addi $a1, $a1, 1		# increment $a1 to next char in string
   b loop_find_end
   
end_found:
sb $zero, ($a1)		# overwrite the newline w/null terminator
subi $a1, $a1, 1	# sub 1 so pointed to last char in string (not newline char)

# Reverse the string in place
move $a2, $a0		#makes another copy of string start

loop_reverse:
   bge $a2, $a1, end_reverse	# if $a2 >= $a1, there are no more chars to swap
   lb $t1, ($a1)
   lb $t2, ($a2)
   #swap
   sb $t1, ($a2)
   sb $t2, ($a1)
   addi $a2, $a2, 1	#inc and dec indexes
   addi $a1, $a1, -1	#
   b loop_reverse

end_reverse:

# Print out the output prompt
la $a0, output_prompt
li $v0, 4
syscall

# Print out the string
la $a0, user_string	# updated string stored over first one
syscall 	# $v0 still has value of 4 so can just call syscall


# Terminate string
li $v0, 10
syscall
