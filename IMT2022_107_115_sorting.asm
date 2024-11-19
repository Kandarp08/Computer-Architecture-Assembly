#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"
	inp_statement: .asciiz "Enter No. of integers to be taken as input: "
	inp_int_statement: .asciiz "Enter starting address of inputs(in decimal format): "
	out_int_statement: .asciiz "Enter starting address of outputs (in decimal format): "
	enter_int: .asciiz "Enter the integer: "	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1
jal print_inp_statement	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal print_inp_int_statement
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal print_out_int_statement
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal print_enter_int
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
#The below function adds 10 to the numbers. You have to replace this with
#your code

#Storing the values of $t2, $t3 in registers $s2, $s3 as they're going to be changed later.
#$s5 represents the iterative variable k 
mySort:
    addi $s2, $t2, 0
    addi $s3, $t3, 0
    add $s5, $0, $0

#Below procedure copies elements from inputAddress to outputAddress so that they can be modified only in the outputAddress
copyElements:
#This is a for loop to copy the elements
    beq $s5, $t1, copyElementsEnd 
    lw $s4, 0($s2)
    sw $s4, 0($s3)
    addi $s2, $s2, 4
    addi $s3, $s3, 4
    addi $s5, $s5, 1
    j copyElements
    
    copyElementsEnd: #After the end of the loop, $s6 which represents the iterative variable j is initialised to 0
        add $s6, $0, $0

#Below sorting algorithm uses the iterative version of the selection sort to sort the elements in ascending order
outerLoop: 
    beq $s6, $t1, outerLoopEnd
#Here we calculate the address of toSort[j], and store the result in $s0 which represents the variable minimum
    sll $t5, $s6, 2
    add $t5, $t5, $t3
    lw $s0, 0($t5)
    addi $s1, $s6, 0  
#$s7 represents the inner iterative variable i & $s1 represents the minIndex variable
    addi $s7, $s6, 1

innerLoop:
   
    beq  $s7, $t1, innerLoopEnd
#Here we calculate the address of toSort[i], and store the result in $t9
    sll $t7, $s7, 2
    add $t7, $t7, $t3
    lw  $t9, 0($t7)
#If condition to check whether toSort[i] is less than 'minimum' variable
    slt $s4, $t9, $s0
    
    addi $s5, $0, 1
    
    beq $s4, $s5, if_condn
#The after_if_condn is used to increment the value of the variable i to move to the next iteration of the inner loop
    after_if_condn:    
        addi $s7, $s7, 1
        j innerLoop
#Below if_condn tells us to set minimum = toSort[i] & minIndex = i & then move to the next iteration of the loop
    if_condn:   

        addi $s0, $t9, 0
       	addi $s1, $s7, 0

        j after_if_condn
    
    innerLoopEnd:
#After the innerLoop is done, swap the two elements: toSort[j] and toSort[minIndex]
        lw $s2, 0($t5)
        sw $s0, 0($t5)
        sll $s5, $s1, 2
        add $s5, $s5, $t3

        sw $s2, 0($s5)
    
        addi $s6, $s6, 1            
        j outerLoop

outerLoopEnd:

#endfunction
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1	
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

#print number of inputs statement
print_inp_statement: li $v0,4
		la $a0,inp_statement
		syscall 
		jr $ra
#print input address statement
print_inp_int_statement: li $v0,4
		la $a0,inp_int_statement
		syscall 
		jr $ra
#print output address statement
print_out_int_statement: li $v0,4
		la $a0,out_int_statement
		syscall 
		jr $ra
#print enter integer statement
print_enter_int: li $v0,4
		la $a0,enter_int
		syscall 
		jr $ra
