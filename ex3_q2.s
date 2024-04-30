.global main
.text

main:

addi $4, $0, '*' #sets replacement character
lw $11, 0x70003($0) #gets status register value
andi $11, $11, 0x1 #checks transmit data
beqz $11, main #if not ready loop until it is
lw $3, 0x70001($0) #gets character from serial port 1
sw $3, 0x70000($0) #sends character to serial port 1

sgei $3, $3, 'a' #if character is greater or equal to 'a'then dont change char
beqz $3, changeChar
slei $3, $3, 'z' #if character is less than or equal to 'z' then dont change char
beqz $3, changeChar

j main

changeChar: #if char is not lowercase change to replacement character
 sw $4, 0x70000($0)
 j main

