
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------    
loop:
            lb t0, 0(a0) #fortonei to gramma
            lb t1, 0(a1) #fortonei to gramma
            beq t1, zero, return1 #an isoutai me "" to gramma sto t1
            beq t0, zero, return0 #an isoutai me "" to gramma sto t0
            beq t0, t1, skip #an t0 = t1
            blt t0, t1, return0 #an t0<t1
            bge t0, t1, return1 #an t0>=t1
            j loop
         
skip:
            addi a0, a0, 1 #allazei gramma
            addi a1, a1, 1
            j loop

return0:
            add a0, zero, zero #vazei ston a0 to 0
            jr ra
return1:
            addi a0, zero, 1 #vazei ston a0 to 1
            jr   ra 
            
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            
            addi sp, sp, -8
            sw ra, 4(sp) 
            sw s1, 0(sp) #dhmiourgia stoivas gia 2
            
            add s1, zero, a1
            add ra, zero, a0 #topo8etei tis times ton a0 kai a1
            

            addi t4, zero, 1 
            add t3, zero, zero #prosorinoi registers gia 0 kai 1
            
            
            jal str_ge # call str_ge subroutine
            
            lw s1, 0(sp) #restore register s1
            lw ra, 4(sp) #restore register ra
            beq s1, t4, exit1 
            beq s1, t3, exit1 #an to size einai 1 h 0 gyrna 1
            beq ra, t4, exit2 
            bne ra, t3, exit3 #an den einai in ascending order kanei exit gia loop
         
loop1:        
            addi s1, s1, -1
            jal str_ge #kanei call pali thn str_ge gia size -1
            lw s1, 0(sp) #restore register s1
            lw ra, 4(sp) #restore register ra
            beq ra, t4, exit2
            bne ra, t3, exit1
            
            
            addi sp, sp, 8 #kleisimo ths stoivas.
            jr ra

exit3:        
            j    loop1 #gurizei piso gia na kanei size -1

exit1:
            addi a0, zero, 1 #vazei ston a0 to 1
            jr   ra
            
exit2:     
            add a0, zero, zero #vazei ston a0 to 0
            jr   ra
