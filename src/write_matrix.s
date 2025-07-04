    .globl write_matrix

    .text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
# The first 8 bytes of the file will be two 4 byte ints representing the
# numbers of rows and columns respectively. Every 4 bytes thereafter is an
# element of the matrix in row-major order.
# Arguments:
# a0 (char*) is the pointer to string representing the filename
# a1 (int*) is the pointer to the start of the matrix in memory
# a2 (int) is the number of rows in the matrix
# a3 (int) is the number of columns in the matrix
# Returns:
# None
# Exceptions:
# - If you receive an fopen error or eof,
# this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
# this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
# this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

# Prologue
    addi   sp, sp, -36
    sw     s0, 0(sp)
    sw     s1, 4(sp)
    sw     s2, 8(sp)
    sw     s3, 12(sp)
    sw     s4, 16(sp)
    sw     s5, 20(sp)
    sw     s6, 24(sp)
    sw     s7, 28(sp)
    sw     ra, 32(sp)


    mv     s0, a0           # pointer to a string: filename
    mv     s1, a1           # pointer to address in memory : matrix
    mv     s2, a2           # row int
    mv     s3, a3           # col int

    mv     a1, s0
    li     a2, 1

    jal    fopen

    mv     s4, a0           # file descriptor

    li     t0, -1
    beq    s4, t0, wrong_93

# write row and column to the binary file
    addi   sp, sp, -36
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     ra, 12(sp)
    sw     a0, 16(sp)
    sw     a1, 20(sp)
    sw     a2, 24(sp)
    sw     a3, 28(sp)
    sw     a4,32(sp)


    li     a0, 8
    jal    malloc
    mv     s7, a0
    sw     s2, 0(a0)
    sw     s3, 4(a0)


    mv     a1, s4           # file descriptor
    mv     a2, a0           # pointer to the buffer
    li     a3, 2            # number of elements to write
    li     a4, 4            # bytes of each element

    jal    fwrite

    li     t0, 2
    bne    t0, a0, wrong_94

    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     ra, 12(sp)
    lw     a3, 16(sp)
    lw     a2, 20(sp)
    lw     a1, 24(sp)
    lw     a0, 28(sp)
    lw     a4, 32(sp)
    addi   sp, sp, 36


# write all elements of the matrix
    addi   sp, sp, -32
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     ra, 12(sp)
    sw     a0, 16(sp)
    sw     a1, 20(sp)
    sw     a2, 24(sp)
    sw     a3, 28(sp)

    mv     a1, s4           # file descriptor
    mv     a2, s1           # pointer to the buffer
    mul    a3, s2, s3       # number of elements to write
    li     a4, 4            # bytes of each element

    jal    fwrite

    mul    t0, s2, s3       # number of elements to write
    bne    t0, a0, wrong_94

    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     ra, 12(sp)
    lw     a3, 16(sp)
    lw     a2, 20(sp)
    lw     a1, 24(sp)
    lw     a0, 28(sp)
    addi   sp, sp, 32


# fclose
    addi   sp, sp, -32
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     ra, 12(sp)
    sw     a0, 16(sp)
    sw     a1, 20(sp)
    sw     a2, 24(sp)
    sw     a3, 28(sp)


    mv     a1, s4

    jal    fclose

    li     t0, -1
    beq    a0, t0, wrong_95


    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     ra, 12(sp)
    lw     a3, 16(sp)
    lw     a2, 20(sp)
    lw     a1, 24(sp)
    lw     a0, 28(sp)
    addi   sp, sp, 32

    mv     a0, s7
    jal    free

# Epilogue
    lw     s0, 0(sp)
    lw     s1, 4(sp)
    lw     s2, 8(sp)
    lw     s3, 12(sp)
    lw     s4, 16(sp)
    lw     s5, 20(sp)
    lw     s6, 24(sp)
    lw     s7, 28(sp)
    lw     ra, 32(sp)
    addi   sp, sp, 36


    ret




wrong_93:
    li     a1, 93
    jal    exit2

wrong_94:
    li     a1, 94
    jal    exit2

wrong_95:
    li     a1, 95
    jal    exit2