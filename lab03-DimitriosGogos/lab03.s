# Conversion of RGB888 image to RGB565
# lab03 of MYY505 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

# This directive declares subroutines. Do not remove it!
.globl rgb888_to_rgb565, showImage

.data

image888:  # A rainbow-like image Red->Green->Blue->Red
    .byte 255, 0,     0
    .byte 255,  85,   0
    .byte 255, 170,   0
    .byte 255, 255,   0
    .byte 170, 255,   0
    .byte  85, 255,   0
    .byte   0, 255,   0
    .byte   0, 255,  85
    .byte   0, 255, 170
    .byte   0, 255, 255
    .byte   0, 170, 255
    .byte   0,  85, 255
    .byte   0,   0, 255
    .byte  85,   0, 255
    .byte 170,   0, 255
    .byte 255,   0, 255
    .byte 255,   0, 170
    .byte 255,   0,  85
    .byte 255,   0,   0
# repeat the above 5 times
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0

image565:
    .zero 512  # leave a 0.5Kibyte free space

.text
# -------- This is just for fun.
# Ripes has a LED matrix in I/O tab. To enable it:
# - Go to the I/O tab and double click on LED Matrix.
# - Change the Height and Width (at top-right part of I/O window),
#     to the size of the image888 (6, 19 in this example)
# - This will enable the LED matrix
# - Uncomment the following and you should see the image on the LED matrix!
#    la   a0, image888
#    li   a1, LED_MATRIX_0_BASE
#    li   a2, LED_MATRIX_0_WIDTH
#    li   a3, LED_MATRIX_0_HEIGHT
#    jal  zero, showImage
# ----- This is where the fun part ends!

    la   a0, image888
    la   a3, image565
    li   a1, 19 # width
    li   a2,  6 # height
    jal  ra, rgb888_to_rgb565

    addi a7, zero, 10 
    ecall

# ----------------------------------------
# Subroutine showImage
# a0 - image to display on Ripes' LED matrix
# a1 - Base address of LED matrix
# a2 - Width of the image and the LED matrix
# a3 - Height of the image and the LED matrix
# Caution: Assumes the image and LED matrix have the
# same dimensions!
showImage:
    mul  a4, a2,   a3 # size of the image in pixels (width * height)
loopShowImage:
    beq  a4, zero, returnShowImage
    lbu  t0, 0(a0) # get red
    lbu  t1, 1(a0) # get green
    lbu  t2, 2(a0) # get blue
    slli t0, t0,   16  # place red at the 3rd byte of "led" word
    slli t1, t1,   8   #   green at the 2nd
    or   t2, t2,   t1  # combine green, blue
    or   t2, t2,   t0  # Add red to the above
    sw   t2, 0(a1)     # let there be light at this pixel
    addi a0, a0,   3   # move on to the next image pixel
    addi a1, a1,   4   # move on to the next LED
    addi a4, a4,   -1  # decrement pixel counter
    j    loopShowImage
returnShowImage:
    jalr zero, ra, 0
# ----------------------------------------

rgb888_to_rgb565:
# ----------------------------------------
# Write your code here.

    mul  a4, a2, a1 # size of the image in pixels (width * height)
loopRGB:
    beq  a4, zero, ShowImage
    lbu  t0, 0(a0) # get red
    lbu  t1, 1(a0) # get green
    lbu  t2, 2(a0) # get blue
    
    andi t0, t0, 0xf8 #mask for red
    slli t0, t0, 8 
    
    andi t1, t1, 0xfc #mask for green
    slli t1, t1, 3 
    
    andi t2, t2, 0xf8 #mask for blue
    srli t2, t2, 3 
    

    or   t2, t2,   t1  # combine green, blue
    or   t2, t2,   t0  # Add red to the above
    sh   t2, 0(a3)     # let there be light at this pixel
    addi a0, a0,   3   # move on to the next image pixel
    addi a3, a3,   2   # move on to the next LED besause is a 2 dimensions image
    addi a4, a4,   -1  # decrement pixel counter
    j loopRGB

ShowImage:
# You may move the "return" instruction (jalr zero, ra, 0).
    jalr zero, ra, 0


