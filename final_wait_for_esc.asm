.data
controller_addr: .word 0xFFFF0000


.text
wait_for_esc:
la $a2, controller_addr		# controll addy in $a1
lw $a1, ($a2)
string_input_loop:
   # Wait until char is available
   lw $t1, 0($a1) 			# read the keyboard control word
   andi $t1, $t1, 1			# isolate ready bit
   beqz $t1, string_input_loop		# keep waiting if char not ready
     lw $t0, 4($a1)			# read the inputted char
     beq $t0, 27, string_input_done	# leave loop if esc key
   b string_input_loop
string_input_done:


# Return to user
jr $ra