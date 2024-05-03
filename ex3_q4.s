.global main
.text 

main: 
    subui $sp, $sp, 1
    sw $ra, 0($sp)

multiTask: #loops giving each job a turn
    jal serial_job
    jal parallel_job
    j multiTask

returnToMulti: #returns 
    jr $ra

serial_job:
    addi $4, $0, '*' #sets replacement character
    lw $11, 0x70003($0) #gets status register value
    andi $11, $11, 0x1 #checks transmit data
    beqz $11, returnToMulti #if not ready loop until it is
    lw $3, 0x70001($0) #gets character from serial port 1
    sw $3, 0x70000($0) #sends character to serial port 1

    sgei $3, $3, 'a' #if character is greater or equal to 'a'then dont change char
    beqz $3, changeChar
    slei $3, $3, 'z' #if character is less than or equal to 'z' then dont change char
    beqz $3, changeChar

    j multiTask

changeChar: #if char is not lowercase change to replacement character
    sw $4, 0x70000($0)
    j multiTask
    
parallel_job:
    start:
        addi $7, $0, 0xffff #for all leds to be on register
        addi $2, $0, 0 #for the switches value to be reset

    pollingLoop:
        lw $2, 0x73000($0) #gets value from the switches

        lw $3, 0x73001($0) #loads the value from push button
        beqz $3, returnToMulti #waits for the value
        andi $4, $3, 0x1 #looks to see if the push button value is button 0
        bnez $4, leaveSwitches #if it is go to leave the switches
        andi $4, $3, 0x2 #looks to see if the push button value is button 1
        bnez $4, invertSwitches # if it is go to invert the switches
        andi $4, $3, 0x4 #looks to see if the push button value is button 2
        bnez $4, endProgram  #if it is go to end the program

    checkMultiple: #checks to see if we want to turn all leds off or on
        remi $5, $2, 4 #checks the multiple
        bnez $5, turnOffLeds #if it isn't a multiple go to turn off the Leds

        sw $7, 0x7300A($0) #turns all the leds on
        j writeToSSD

    turnOffLeds: #turns off all the leds
        sw $0, 0x7300A($0)
        j writeToSSD

    leaveSwitches: #leaves the switches as is
        j checkMultiple

    invertSwitches: #inverts all of the switches
        xori $2, $2, 0xffff
        j checkMultiple

    endProgram: #ends the program and returns to $ra
        lw $ra, 0($sp)
        addui $sp, $sp, 1
        jr $ra #exit program

    writeToSSD:
        sw $2, 0x73009($0) #SHOWS lower right SSD 
        srli $2, $2, 4
        sw $2, 0x73008($0) #SHOWS lower left SSD
        srli $2, $2, 4
        sw $2, 0x73007($0) #SHOWS upper right SSD
        srli $2, $2, 4
        sw $2, 0x73006($0) #SHOWS upper left SSD
        lw $ra, 0($sp)
        j multiTask