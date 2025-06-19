
.data

array: .word 1, 0, 1, 12, 0, 1, 4

.text

    la a0, array
    li a1, 7    # unsigned
    li a2, 1
prog:
#-----------------------------
# Write your code here!
    add s0 ,zero, a1
    addi t2, zero, -1

loop:
    beq a1, zero not_found
    blt s0, t2 not_found
    slli t0, s0 ,2
    add t0, t0, a0
    lw t1,0(t0)
    beq t1, a2, found
    addi s0, s0 , -1
    j loop

not_found:
    add s0, zero, zero
    j done

found:
    add s0, t0, zero
    add a0, t0, zero
    j done
 
    
 
    

# Do not remove the prog label or write code above it!
#-----------------------------
done:
    addi a7, zero, 10 
    ecall
