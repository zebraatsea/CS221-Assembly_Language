#Demo Hello World program

#Program data goes here
.data
greeting: .asciiz "Hello World!"

#Program instructions goes here
.text
#print out the string via system call 4
li $v0, 4		# setup for system call 4 (print string)
la $a0, greeting	# tell the systme call what string to print (via address/label)
syscall			# triggers the system call

#terminate the program
li $v0, 10
syscall