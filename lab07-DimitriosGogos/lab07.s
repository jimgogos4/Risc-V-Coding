# lab07.s - move a "ball" in the LED matrix using the D-pad. 
#  The ball is normally white and turns red when it reaches the edge of the matrix.
# To run this program, make sure that you have instantiated a "D-pad"
# and a "LED Matrix" peripheral in the "I/O" tab.

.data
# Any memory-based data are held here

.text
# Code segment
    

 
    li a1, LED_MATRIX_0_BASE
    li a2, LED_MATRIX_0_WIDTH
    li a3, LED_MATRIX_0_HEIGHT
    li t4, D_PAD_0_UP
    li t6, D_PAD_0_DOWN
    li t5, D_PAD_0_LEFT
    li t3, D_PAD_0_RIGHT
    
    
    jal  zero, putblack



    li   a2, 20 # width
    li   a3, 20 # height
    ecall



putblack:
    mul  a4, a2,   a3 # size of the image in pixels (width * height)
loopputblack:
    beq  a4, zero, returnputblack
    lbu  t0, 0(a0) # get red
    lbu  t1, 1(a0) # get green
    lbu  s1, 2(a0) # get blue
    add  t1, t1,  s1    # combine green, blue
    add  t1, t1,  t0  # Add red to the above
    sw   t1, 0(a1)     # let there be light at this pixel
    addi a0, a0,   3   # move on to the next image pixel
    addi a1, a1,   4   # move on to the next LED
    addi a4, a4,   -1  # decrement pixel counter
    j    putblack
returnputblack:
    jalr zero, ra, 0
    

rd_poll:
     lw t0, 0(t0)
     andi t0, t0, 0x01
     beq t0, zero, rd_poll
#end of loop
     lw a0, 4(t0)
     
    
wr_poll:
     lw t0, 0(t0)
     andi t0, t0, 0x01
     beq t0, zero, wr_poll
#end of loop
     sw a0, 4(t0)

     


