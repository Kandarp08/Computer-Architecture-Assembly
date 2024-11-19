# Selection sort algorithm (without template)

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