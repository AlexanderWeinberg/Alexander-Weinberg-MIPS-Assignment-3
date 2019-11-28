#My ID: 02876360 %11 = 3 +26 = Base 29

.data
user_input: .space 1001	   #makes 1000 spaces for the user input
endl: .asciiz "\n"	   #makes asciiz character for a new line
NaN_msg: .asciiz "NaN"  #makes asciiz NaN message
comma_msg: .asciiz ","      #makes asciiz comma character

.text

main:
li $v0,8 	      # takes in and reads input
la $a0, user_input    #puts the users input into the $a0 register
li $a1, 1001            #takes in 1000 spaces from the user input even though it says 1001 (NULL)
syscall
jal SubprogramA      #unconditional jump to subprogramA

continue_1:
	j print #jumps to print loop

############################################################################
SubprogramA:
	sub $sp, $sp,4 #creates spaces in the stack
	sw $a0, 0($sp) #stores input into the stack
	lw $t0, 0($sp) # stores the input into $t0
	addi $sp,$sp,4 # moves the stack pointer up
	move $t6, $t0 # stores the begining of the input into $t6
start:
	li $t2,0 #used to check for space or tabs within the input
	li $t7, -1 #used for invaild input
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	#beq $s0, 0, finish
	beq $s0, 9, skip # checks if the bit is a tabs character 
	beq $s0, 32, skip #checks if the bit is a space character
	move $t6, $t0 #store the first non-space/tab character
	j loop # jumps to the beginning of the loop function

skip:
	addi $t0,$t0,1 #move the $t0 to the next element of the array
	j start 	#jumps to start loop
loop:
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, substring# check if the bit is null
	beq $s0, 10, substring #checks if the bit is a new line 	
	addi $t0,$t0,1 #move the $t0 to the next element of the array	
	beq $s0, 44, substring #check if bit is a comma
check:
	bgt $t2,0,invalid_loop #checks to see if there were any spaces or tabs in between valid characters
	beq $s0, 9,  gap #checks to see if there is a tab characters
	beq $s0, 32, gap #checks to see if there is a space character
	ble $s0, 47, invalid_loop # checks to see if the ascii less than 48
	ble $s0, 57, vaild # checks to see if the ascii less than 57(integers)
	ble $s0, 64, invalid_loop # checks to see if the ascii less than 64
	ble $s0, 84, vaild	# checks to see if the ascii less than 84(capital letters)
	ble $s0, 96, invalid_loop # checks to see if the ascii less than 96
	ble $s0, 116, vaild 	# checks to see if the ascii less than 116(lowercase letters)
	bge $s0, 117, invalid_loop # checks to see if the ascii greater than 116

gap:
	addi $t2,$t2,-1 #keeps track of spaces and tabs
	j loop

vaild:
	addi $t3, $t3,1 #keeps track of how many valid characters are in the substring
	mul $t2,$t2,$t7 #if there was a space before a this valid character it will change $t2 to a positive number
	j loop #jumps to the beginning of loop	

invalid_loop:
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, insubstring# check if the bit is null
	beq $s0, 10, insubstring #checks if the bit is a new line 	
	addi $t0,$t0,1 #move the $t0 to the next element of the array	
	beq $s0, 44, insubstring #check if bit is a comma
	#addi $t3, $t3,1 #check track of how many valid characters are in the substring
	j invalid_loop #jumps to the beginning of loop


insubstring:
	addi $t1,$t1,1 #keeps track of the amount substring 	
	sub $sp, $sp,4# creates space in the stack
	sw $t7, 0($sp) #stores what was in $t6 into the stack
	move $t6,$t0  # store the pointer to the bit after the comma
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, continue_1# check if the bit is null
	beq $s0, 10, continue_1 #checks if the bit is a new line 
	beq $s0,44, invalid_loop #checks if the next bit is a comma
	li $t3,0 #resets the amount of valid characters back to 0
	li $t2,0 #resets my space and tabs checker back to zero
	j loop
substring:
	bgt $t2,0,insubstring #checks to see if there were any spaces or tabs in between valid characters
	bge $t3,5,insubstring #checks to see if there are more than 4 for characters
	addi $t1,$t1,1 #check track of the amount substring 	
	sub $sp, $sp,4 # creates space in the stack
	sw $t6, 0($sp) #stores what was in $t6 into the stack
	move $t6,$t0  # store the pointer to the bit after the comma
	lw $t4,0($sp) #loads what was in the stack at that posistion into $t4
	li $s1,0 #sets $s1 to 0 
	jal Subprogram_B
	lb $s0, ($t0) # loads the bit that $t0 is pointing to
	beq $s0, 0, continue_1 # check if the bit is null
	beq $s0, 10, continue_1 #checks if the bit is a new line 
	beq $s0,44, invalid_loop #checks if the next bit is a comma
	li $t2,0 #resets my space/tabs checker back to zero
	j loop
Subprogram_B:
	beq $t3,0,finish #check how many charcter are left to convert 
	addi $t3,$t3,-1 #decreases the amount of charaters left to convert
	lb $s0, ($t4) # loads the bit that will be converted
	addi $t4,$t4,1	# moves to the next element in the array
	j Subprogram_C 
continue_2:
	sw $s1,0($sp)	#stores the converted number
	j Subprogram_B
Subprogram_C:
	move $t8, $t3	   #stores the amount of characters left to use as an exponent
	li $t9, 1	    # $t9 represents 30 to a certian power and set equal to 1
	ble $s0, 57, number #sorts the bit to the apporiate function
	ble $s0, 84, valid_CAP
	ble $s0, 116, valid_low
number:
	sub $s0, $s0, 48	#converts interger bits 
	beq $t3, 0, combine	# if there are no charaters left that mean the exponent is zero
	li $t9, 29		#29 for my Base-29
	j exponent		#jumps to exponent loop
valid_CAP:
	sub $s0, $s0, 55 #converts uppercase bits
	beq $t3, 0, combine # if there are no charaters left that mean the exponent is zero
	li $t9, 29
	j exponent
valid_low:
	sub $s0, $s0, 87 #converts lowercase bits
	beq $t3, 0, combine # if there are no charaters left that mean the exponent is zero
	li $t9, 29
	j exponent
exponent:
	#raises my base to a certain exponent by muliplying itself repeatly
	ble $t8, 1, combine	#if the exponet is 1 there is no need to multiply the base by itself
	mul $t9, $t9, 29 	# multpling my base by itself to simulate raising the number to a power
	addi $t8, $t8, -1	# decreasing the exponent
	j exponent		#jumps too exponent loop
combine:
	mul $s2, $t9, $s0	#multiplied the converted bit and my base raised to a power
	add $s1,$s1,$s2		# adding the coverted numbers together 
	j continue_2		#jumps too continue_2 loop
finish : jr $ra			#jumps back to substring

print:
	mul $t1,$t1,4 #getting the amount of space needed to move the stack pointer to the beginning of the stack
	add $sp, $sp $t1 #moving the stack pointer to the beginning of the stack	
done:	
	sub $t1, $t1,4	#keeping track of amount of elements left
	sub $sp,$sp,4 #moving the stack pointer to the next element	
	lw $s7, 0($sp)	#storing that element into $s7
	beq $s7,-1,invalidprint #checks to see if element is invalid	
	li $v0, 1
	lw $a0, 0($sp) #prints element
	syscall
comma:
	beq $t1, 0,Exit #if there are now elements left it terminates the program
	li $v0, 4
	la $a0, comma_msg #prints a comma
	syscall
	j done
invalidprint:
	li $v0, 4
	la $a0, NaN_msg #prints a nonvaild input
	syscall	
	j comma 	#jumps to print a comma
Exit:
	li $v0, 10	# exits program
	syscall
#############################################################################

