# The functions for the *STRING LIBRARY*
## String Library: Write a library of functions to support more complicated string operations such as 
##                 concatenation, substring search, etc.

.data
input_prompt: .asciiz "Enter a string: "
output_prompt: .asciiz "\nYour string: "
reversed_prompt: .asciiz "\nYour reversed string: "
no_vowels_prompt: .asciiz "\nYr strng: "
no_spaces_prompt: .asciiz "\nYourstring: "
concat_prompt: .asciiz "\nYour new string: "
substring_y_prompt: .asciiz "\nSubstring found at: "
substring_n_prompt: .asciiz "\nNo Substring Found"


.text
#################################
### GET USER INPUT FOR STRING ###
#################################
.globl get_string
get_string:
# Step A: Read args from stack
lw $a3, 0($sp)      # read array address
# Step B: Business logic

   # Print out the input prompt
   la $a0, input_prompt
   li $v0, 4
   syscall

   # Ask user to input a string
   #la $a0, $a3
   li $a1, 49	# max chars to read
   li $v0, 8
   syscall

# Step C: Write return values to the stack
lw $a3, 0($sp)
# Step D: Return to caller
jr $ra

###############################
### REVERSE STRING FUNCTION ###
###############################
.globl reverse_string
reverse_string:
# Step A: Read args from stack
lw $a0, 0($sp)      # read array address
# Step B: Business logic
   # Iterate to find end of string and replace the newline char with
   # null terminator, and then decrement by 1
   move $a1, $a0		#copies string from $a0 to $a1
   reverse_loop_find_end:
      lb $t0, ($a1)  		# read char from byte (into $t0, from string $a1)
      beq $t0, 10, reverse_end_found 	# if $t0 is newline char (10), leave loop
      addi $a1, $a1, 1		# increment $a1 to next char in string
      b reverse_loop_find_end
   
   reverse_end_found:
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
# Step C: Write return values to stack
sw $a1, 4($sp)
# Step D: Return to caller
jr $ra


##############################
### REMOVE VOWELS FUNCTION ###
##############################
.globl remove_vowels
remove_vowels:
# Step A: Read args from stack
la $a0, 0($sp)
# Step B: Business logic
   move $a1, $a0
   no_vowel_loop:
      lb $t0, ($a0)  			# read char from byte (into $t0, from string $a1)
      beq $t0, 10, no_vowel_loop_end	# newline --> leave
      beqz $t0, no_vowel_loop_end	# null --> leave
         beq $t0, 65, skip_add		#A
         beq $t0, 69, skip_add		#E
         beq $t0, 73, skip_add		#I
         beq $t0, 79, skip_add		#O
         beq $t0, 85, skip_add		#U
         beq $t0, 97, skip_add		#a
         beq $t0, 101, skip_add	#e
         beq $t0, 105, skip_add	#i
         beq $t0, 111, skip_add	#o
         beq $t0, 117, skip_add	#u
      sb $t0, ($a1)
      skip_add:
         addi $a0, $a0, 1
         addi $a1, $a1, 1
         b no_vowel_loop
      
      no_vowel_loop_end:
         addi $a1, $a1, 1
         sb $t0, ($a1)			#store newline/null to new string
   
# Step C: Write return values to stack
sw $a1, 4($sp)
# Step D: Return to caller
jr $ra


##############################
### REMOVE SPACES FUNCTION ###
##############################
.globl remove_spaces
remove_spaces:
# Step A: Read args from stack
la $a0, 0($sp)
# Step B: Business logic
   move $a1, $a0
   no_space_loop:
      lb $t0, ($a0)  			# read char from byte (into $t0, from string $a1)
      beq $t0, 10, no_space_loop_end	# newline --> leave
      beqz $t0, no_space_loop_end	# null --> leave
         beq $t0, 20, skip_add_space	#' '
      sb $t0, ($a1)
      skip_add_space:
         addi $a0, $a0, 1
         addi $a1, $a1, 1
         b no_space_loop
      
      no_space_loop_end:
         addi $a1, $a1, 1
         sb $t0, ($a1)			#store newline/null to new string
# Step C: Write return values to stack
sw $a1, 4($sp)
# Step D: Return to caller
jr $ra


##############################
### CONCAT STRING FUNCTION ###
##############################
.globl concat_string
concat_string:
# Step A: Read args from stack
la $a0, 0($sp)
la $a1, 4($sp)
# Step B: Business logic
   move $a2, $a0
   # Iterate to find end of string
   concat_loop_find_end:
      lb $t0, ($a0)  		# read char from byte (into $t0, from string $a0)
      beq $t0, 10, concat_end_found 	# if $t0 is newline char (10) or null terminator (0), leave loop
      beqz $t0, concat_end_found
      addi $a0, $a0, 1		# increment $a0 to next char in string
      b concat_loop_find_end
   concat_end_found:
   
   concat_loop:
      lb $t0, ($a1)
      beq $t0, 10, concat_end_loop 	# if $t1 is newline char (10) or null terminator (0), leave loop
      beqz $t0, concat_end_loop
      sb $t0, ($a2)		# add new char 
      addi $a1, $a1, 1		# increment $a1 to next char in mew string
      addi $a2, $a2, 1		# increment $a2 for next char
      b concat_loop
   concat_end_loop:
   sb $t0, ($a2)		#add newline/null to end of string
   
# Step C: Write return values to stack
sw $a2, 8($sp)
# Step D: Return to caller
jr $ra


#################################
### SUBSTRING SEARCH FUNCTION ###
#################################
.globl substring_search
substring_search:
# Step A: Read args from stack
# Step B: Business logic
# Step C: Write return values to stack
# Step D: Return to caller
jr $ra


##############################
### STRING LENGTH FUNCTION ###
##############################
.globl string_length
string_length:
# Step A: Read args from stack
la $a1, 0($sp)
# Step B: Business logic
   li $t1, 0			# counter var
   # Iterate to find end of string
   length_loop_find_end:
      lb $t0, ($a1)  		# read char from byte (into $t0, from string $a1)
      beq $t0, 10, length_end_found 	# if $t0 is newline char (10) or null terminator (0), leave loop
      beqz $t0, length_end_found
      addi $a1, $a1, 1		# increment $a1 to next char in string
      addi $t1, $t1, 1		# increment $t1 (counter)
      b length_loop_find_end
   
   length_end_found:
# Step C: Write return values to stack
sw $t1, 4($sp)
# Step D: Return to caller
jr $ra