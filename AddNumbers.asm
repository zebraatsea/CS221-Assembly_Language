# Program asks the user to enter two numbers and outputs their sum

# any data the program will use
.data 
input_prompt: .asciiz "Enter a number:  "
output_prompt: .asciiz "The sum is:  "

# program instuctions
.text 
# Print out prompt for user to input 1st number
li $v0, 4
la $a0, input_prompt
syscall
# Get the first number
li $v0, 5
syscall
move $t0, $v0
# Print the prompt for user to input 2nd number
li $v0, 4
syscall
# Get the second number
li $v0, 5
syscall
move $t1, $v0
# Calculate sum
add $t2, $t0, $t1
# Print out output string
li $v0, 4
la $a0, output_prompt
syscall
# Print the actual sum
li $v0, 1
move $a0, $t2
syscall
# Terminate program
li $v0, 10
syscall


### HOW TO DO BOOLS IN ASSEMBLY LANG
# **exapmle**
# if($s6 >= 0){				bltz $s6, Quit
#    $s6 = $s6 - 1;			addi $s6, $s6, -1
# }
# else {
#    goto Quit;
# }

# **conditional branches -- in assem lang if pass check, skip next lines
# beqz --> branch if == 0 --> beqz $t0, label
# bltz --> branch if < 0
# blez --> branch if <= 0
# bnez --> branch if != 0
# bgtz --> branch if > 0
# bgez --> branch if >= 0
# **unconditional branches -- force branch
# b --> branch to label --> b label


### MULTIPLICATION IN ASSEMBLY LANG
# **general registers only 32 bits, if have a num that needs 64, it goes to high (upper bits) and low (lower bits) registers
# **example**
# mult $a1, $s1  <-- auto puts in hi and lo registers
# mfhi $v0
# mflo $v1
# **example**
# mul $t2, $t0, $t1  <--stores in $t2
# **high risk of overflow if more than 32 bits are needed


### DIVISION IN ASSEMBLY LANG
# **quotient saved in low and remander saved in hi
# **example**
# div $a1, $s1  --> $a1 / $s1
# mflo $v0
# mfhi $v1


### LOOPS IN ASSEMBLY LANG
# **example: loop that adds nums 1-99**
# move $a0, $0
# li $t0, 99
# loop  <-- label name
# add $a0, $a0, $t0
# addi $t0, $t0, -1
# bnez $t0, loop
# li $v0, 1
# syscall
# li $v0, 10
# syscall


### LOADING VALUES FROM MEMORY
# **example**
# lw $s1, 8($a0)
# load word - store - from where
# ( ) <-- works like de-reference * in c++
# 8 <-- offset in bytes --> $a0 + 8    --if no num there, displacement assumed to be 0
# **psuedo: #s1 = Mem[$a0 + 8]
