.data
var_x:.word 2
var_y:.word 32

.text
.globl main

main:
	
	lw $s1,var_y #Y , vazio por enquanto
	addi $s1,$s1,-1
	
	lw $s4,var_x #LO multiplicand
	li $s5,0 #HI multiplicand
	
	li $s2,0 #LO product
	li $s3,0 #HI product
	li $t7,0

Potencia:
	beq $a1,$s1,exit
	lw $s0,var_x #multiplier
	addu $s4,$s4,$s2
	addu $s5,$s5,$s3
	li $s2,0
	li $s3,0
	
	Multiplication:
		Significant:
			andi $t2,$s0,1
			beq $t2,$0 , Shift #Check the less significant multiplier bit is 0
		
		Sum:
			addu $t4,$s4,$s2 #Sum multiplicant LO + product LO , and set in t4
			sltu $t5,$t4,$s2 #Check if the total sum is smaller than product LO
			sltu $t6,$t4,$s4 #Check with the total sum is smaller than multiplicant LO.
		
			addu $s2,$t4,$0 #Put the resultant sum in product LO
			addu $s3,$s5,$s3 # sum product HI e multiplicant HI
			or $t7,$t6,$t5 # or to see if the sum is bigger than the 2 number, set to 0
			beq $t7,$0,Shift #if t7 set , shift the number
			addiu $s3,$s3,1 #if is not setted ,sum product HI with 1
	
		Shift:
			srl $s0,$s0,1 #Shift right multiplicant
			andi $t3,$s4,0x80000000 # and with 10000000000000... and multiplicant LO
		
			sll $s5,$s5,1 #Shift left multiplicant HI
			sll $s4,$s4,1 #Shift left multiplicant LO
			beq $t3,$0,Counter #if result is 0, only shift LO
		HI:
			addiu $s5,$s5,1 #1+ multiplicant HI
	
		Counter:
			bne $s0,$0, Significant #with multiplier is 0
	
	li $t2,0
	li $t3,0
	li $t4,0
	li $t5,0
	li $t6,0
	li $t7,0
		
	li $s4,0 #zero LO multiplicand
	li $s5,0 #zero HI multiplicand
	addi $a1,$a1,1
	j Potencia
exit:	
	#so funciona se o resultado couber em 32 bits
	li $v0, 1
	add $a0, $s2, $zero
	syscall
	
	li $v0, 10
	syscall