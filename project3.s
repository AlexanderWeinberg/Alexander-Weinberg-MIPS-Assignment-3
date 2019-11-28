#My ID: 02876360 %11 = 3 +26 = Base 29

.data
user_input: .space 1001	   #makes 1000 spaces for the user input
endl: .asciiz "\n"	   #makes asciiz character for a new line
NaN_msg: .asciiz "NaN"  #makes asciiz NaN message
comma: .asciiz ","      #makes asciiz comma character

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
SubprogramB:

SubprogramC:




Exit:
	li $v0, 10	# exits program
	syscall
#############################################################################

#saved registers
#la $al, user_input
#li $a0, 0 #register to keep track of final output set to 0

la $s1, 0     #register to keep track of final output set to 0
la $s2, 0     #register to keep track of when a character is found
la $s3, 0     #register to keep track of spaces
la $t5, 0     #register to keep  track of the strings length
la $t3, 1     #register to keep track of exponent

li $v0,8 	      # takes in and reads input
la $a0, user_input    #puts the users input into the $a0 register
li $a1, 1001            #takes in 1000 spaces from the user input even though it says 1001 (NULL)
syscall

move $t0, $a0         #moves the values in the $a0 to $t0 temporary register

jal subprogram		#jumps to the subprogram


final:		#runs if the character is valid
li $v0, 4        #prints out a string
la $a0, endl    #prints the new line character making it skip a line
syscall

move $a0, $s1	#moves the values in $s1 to $a0
li $v0, 1       #prints out an integer
syscall

li $v0, 10    #exits the program
syscall




invalid: 	#runs if the character is invalid

li $v0, 4        #prints out a string
la $a0, endl    #prints the new line character making it skip a line
syscall

li $v0, 4        #prints out a string
la $a0, NaN_msg    #prints the NaN message
syscall

li $v0, 10    #exits the program
syscall




subprogram:


loop:		      #initializes loop to find if any character is found and iterates to count entire string
lb $a0 ($t0)          #load the bit for the $t0 position in $a0
addi $t0, $t0, 1       # iterates the $t0 postion in $a0
addi $t5, $t5, 1       # iterates the $s5 register to keep track of the string length
beqz $a0, end_of_loop    #checks if the Null character is found and if so sends it to end_loop
j loop


end_of_loop:		#after the loop runs and gets string length, this loops backwards to get the vaild values

subu $t0, $t0, 1       # iterates the the position of the bit in $t0 to begin reading from the rightmost bit to the left
lb $a0 ($t0)          #load the bit for the $a0 position in $t0
beq $a0, 32, end_of_loop #checks if a space is found and if so sends back up to end loop
beq $a0, 9, end_of_loop    #checks if a tab is found and if so sends back up to end loop
beq $a0, 44, end_of_loop   #checks if a comma is found to end that loop
j filter		   # jumps to final loop



filter:			  #loops to filter for valid characters 
beq $s2, 5, Exit	  #exits subprogram once 4 characters have been found
addi $s2, $s2, 1    	#iterates the $s2 to know that a char was found
blt $a0, 48, invalid	  #checks if ASCII is less than 48. If true it goes to invalid
blt $a0, 58, valid_number #checks if ASCII is less than 58. If true it goes to valid_number loop
blt $a0, 65, invalid	  #checks if ASCII is less than 65. If true it goes to invalid
blt $a0, 84, valid_CAP	  #checks if ASCII is less than 84. If true it goes to valid_CAP
blt $a0, 97, invalid   	  #checks if ASCII is less than 97. If true it goes to invalid
blt $a0, 116, valid_low    #checks if ASCII is less than 116. If true it goes to valid_low

j invalid			  #jumps to invalid  loop

valid_number:
subu $s4, $a0, 48  #subtracts to find decimal value of char from ASCII 

j calculate		   #jump to calculate loop




valid_CAP:	    #checks for valid capital hexidecimal letters	
subu $s4, $a0, 55   #subtracts to find decimal value of char from ASCII 

j  calculate		   #jump to calculate loop




valid_low:	    #checks for valid lower case hexidecimal letters
subu $s4, $a0, 87   #subtracts to find decimal value of char from ASCII 

j  calculate		   #jump to calculate loop





calculate:
li $t6, 29 		#initializes $t6 as 29 for base 29
multu $s4, $t3		#multiplies the decimal value by the exponent value
mflo $s4		#saves the lower 4 bits in the $s4 register
addu $s1, $s1, $s4	#adds the multiplied value to the sum output
multu $t3, $t6		#multiplies the exponent by base-29 	
j loop			#jump back to loop

Exit: jr $ra		#exits subprogram







