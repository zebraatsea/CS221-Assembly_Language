# Program taht asks user to input radious of circle and prints the 
# circle's area (A = PI * radius * radius)

.data
.align 2	#sets up every mem address so starts on multiple of 4
input_prompt: .asciiz "Enter a radius:  "
error_msg: .asciiz "Error: Radius must be non-negative"
output_prompt: .asciiz "The area of the circle is:  "
PI: .double 3.14159265

.text
# get radius from user
la $a0, input_prompt
li $v0, 4
syscall
li $v0, 7			# read double (result goes into $f0-$f1)
syscall

# validate input (>0)
mtc1 $zero, $f2			# put value zero as an int in $f2
cvt.d.w $f2, $f2		# convert int 0 into double 0.0
c.lt.d $f0, $f2
bc1f valid_input		# branch if input >= 0  -- else print error (input < 0)
   #print error message and terminate
   li $v0, 4
   la $a0, error_msg
   syscall
   b terminate

# calculate area
valid_input:
   mul.d $f2, $f0, $f0		# $f2-$f3 = radius^2 
   ldc1 $f4, PI			# $f4-$f5 = PI
   mul.d $f12, $f2, $f4	# $f12-$f13 = radius^2 * PI = area
   
# print area
   la $a0, output_prompt
   li $v0, 4
   syscall
   li $v0, 3			# expects double printed to be in $f12-$f13
   syscall

# terminate
terminate:
   li $v0, 10
   syscall