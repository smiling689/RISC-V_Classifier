.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

#prelogue
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)

# check for command line
# a1[1]:M0_PATH      4(s1)
# a1[2]:M1_PATH      8(s1)
# a1[3]:INPUT_PATH  12(s1)
# a1[4]:OUTPUT_PATH 16(s1)

    li t0, 5
    bne t0, a0, wrong_89

    mv s0, a2
    mv s1, a1

# list of saved registers
# s0 : flag to print
# s1 : argv(char**)
# s2 : 0(s2):m0's row, 4(s2):m0's col
# s3 : address for m0 matrix
# s4 : 0(s4):m1's row, 4(s4):m1's col
# s5 : address for m1 matrix
# s6 : 0(s6):input matrix's row, 4(s6):input matrix's col
# s7 : address for input matrix
# s8 : 0(s8):m0*input 's row, 4(s8):m0*input 's col
# s9 : m0 * input address
# s10: 0(s10):m1*relu ' s row, 4(s10):m1*releu ' s col
# s11: m1*relu address

	# =====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0
    li a0, 8
    jal malloc
    beqz a0, wrong_88_2
    lw t1, 4(s1) # pointer to name
    mv s2, a0
    mv a0, t1
    addi a1, s2, 0
    addi a2, s2, 4
    jal read_matrix
    mv s3, a0

    # Load pretrained m1
    li a0, 8
    jal malloc
    beqz a0, wrong_88_2
    lw t1, 8(s1) # pointer to name
    mv s4, a0
    mv a0, t1
    addi a1, s4, 0
    addi a2, s4, 4
    jal read_matrix
    mv s5, a0

    # Load input matrix
    li a0, 8
    jal malloc
    beqz a0, wrong_88_2
    lw t1, 12(s1) # pointer to name
    mv s6, a0
    mv a0, t1
    addi a1, s6, 0
    addi a2, s6, 4
    jal read_matrix
    mv s7, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

# 1. LINEAR LAYER:    m0 * input

    lw t0, 0(s2) # row of m0
    lw t3, 4(s6) # col of input

    mul a0, t0, t3
    slli a0, a0, 2
    jal malloc
    beqz a0, wrong_88_2
    mv s9, a0

    li a0, 8
    jal malloc
    beqz a0, wrong_88_2
    mv s8, a0
    lw t0, 0(s2) # row of m0
    lw t3, 4(s6) # col of input   
    sw t0, 0(s8)
    sw t3, 4(s8)

    lw t0, 0(s2) # row of m0
    lw t1, 4(s2) # col of m0
    lw t2, 0(s6) # row of input
    lw t3, 4(s6) # col of input

    mv a0, s3
    mv a1, t0
    mv a2, t1
    mv a3, s7
    mv a4, t2
    mv a5, t3
    mv a6, s9
    jal matmul

# 2. NONLINEAR LAYER: ReLU(m0 * input)

    lw t0, 0(s2) # row of m0
    lw t3, 4(s6) # col of input

    mul t0, t0, t3 # size of array for relu
    mv a0, s9
    mv a1, t0

    jal relu

# 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    li a0, 8
    jal malloc
    beqz a0, wrong_88_2
    mv s10, a0

    lw t0, 0(s4)
    lw t1, 4(s4)
    lw t2, 0(s8)
    lw t3, 4(s8)

    sw t0, 0(s10)
    sw t3, 4(s10)

    mul a0, t0, t3
    slli a0, a0, 2
    jal malloc
    beqz a0, wrong_88_2
    mv s11, a0

    mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s9
    lw a4, 0(s8)
    lw a5, 4(s8)
    mv a6, s11

    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1) # output filename ' s pointer
    mv a1, s11
    lw a2, 0(s10)
    lw a3, 4(s10)

    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s11
    lw t0, 0(s10)
    lw t1, 4(s10)
    li t2, 10
    li t3, 1
    #bne t0, t2, wrong_100
    #bne t1, t3, wrong_100
    mul a1, t0, t1

    jal argmax

    mv t0, a0
    # Print classification
    bnez s0, not_print

    addi sp, sp, -4
    sw t0, 0(sp)

    mv a1, t0
    jal print_int

    lw t0, 0(sp)
    addi sp, sp, 4



    # Print newline afterwards for clarity

    addi sp, sp, -4
    sw t0, 0(sp)

    li a1, '\n'
    jal print_char

    lw t0, 0(sp)
    addi sp, sp, 4


not_print:


# free all memory that malloc
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free    
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free
    mv a0, s11
    jal free

#epilogue
    lw ra, 48(sp)
    lw s11, 44(sp)
    lw s10, 40(sp)
    lw s9, 36(sp)
    lw s8, 32(sp)
    lw s7, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 52

    ret



wrong_89:
    li a1, 89
    jal exit2

wrong_88_2:
    li a1, 88
    jal exit2

wrong_100:
    li a1, 100
    jal exit2