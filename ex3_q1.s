.global main
.text

main:
addi $5, $0, 'a' #for lowercase characters 
checkReadyLower:
    lw $2, 0x71003($0) #store status register
    andi $2, $2, 0x2 #mask for the status
    beqz $2, checkReadyLower #keep checking if ready
#prints lower 
    sw $5, 0x71000($0) #transmit data 
    addi $5, $5, 1 #increments the lowercase characters for next character
    sgei $8, $5, '{' #Sets register 8 to 1 if $5 has incremented to the ending character
    beqz $8, checkReadyLower #loops back up if $8 hasnt reached the end character

addi $5, $0, 'A' #for upper case characters
checkReadyUpper:
    lw $2, 0x71003($0) #store status register
    andi $2, $2, 0x2 #mask for the status
    beqz $2, checkReadyUpper #keep checking if ready
    sw $5, 0x71000($0) #prints upper
    addi $5, $5, 1 #increments the uppercase characters for next character
    sgei $8, $5, '[' #Sets register 8 to 1 if $5 has finished at the ending character
    beqz $8, checkReadyUpper #loops back up if $8 hasnt reached the end character
    
    jr $ra
