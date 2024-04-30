.global main
.text

main:

addi $5, $0, 'a' #for lowercase characters 
printLowerCase:
    j checkReadyLower
    sw $3, 0x71000($0) #transmit data 
    addi $5, $5, 1 #increments the lowercase characters for next character
    seqi $8, $5, '{' #Sets register 8 to 1 if $5 has incremented to the ending character
    beqz $8, printLowerCase #loops back up if $8 hasnt reached the end character

#prints uppercase characters
addi $5, $0, 'A' #for upper case characters
printUpperCase:
    j checkReadyUpper
    sw $3, 0x71000($0) #transmit data
    addi $5, $5, 1 #increments the uppercase characters for next character
    seqi $8, $5, '[' #Sets register 8 to 1 if $5 has finished at the ending character
    beqz $8, printUpperCase #loops back up if $8 hasnt reached the end character
    
    jr $ra

checkReadyLower:
    lw $2, 0x71003($0) #store status register
    andi $2, $2, 0x2 #mask for the status
    beqz $2, checkReadyLower #keep checking if ready
    j printLowerCase #goes to print

checkReadyUpper:
    lw $2, 0x71003($0) #store status register
    andi $2, $2, 0x2 #mask for the status
    beqz $2, checkReadyUpper #keep checking if ready
    j printUpperCase #goes to print