    .globl read_matrix

    .text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
# The first 8 bytes are two 4 byte ints representing the # of rows and columns
# in the matrix. Every 4 bytes afterwards is an element of the matrix in
# row-major order.
# Arguments:
# a0 (char*) is the pointer to string representing the filename
# a1 (int*) is a pointer to an integer, we will set it to the number of rows
# a2 (int*) is a pointer to an integer, we will set it to the number of columns
# Returns:
# a0 (int*) is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
# this function terminates the program with error code 88.
# - If you receive an fopen error or eof,
# this function terminates the program with error code 90.
# - If you receive an fread error or eof,
# this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
# this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

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

# 初始化
    mv     s0, a0           # 对于文件名字符串的指针
    mv     s1, a1           # 对于row的指针
    mv     s2, a2           # 对于col的指针

    mv     a1, s0
    li     a2, 0

    jal    fopen

    mv     t2, a0           # 得到文本描述符
    mv     s3, t2

    li     t1, -1
    beq    t1, t2, wrong_90


# read row
    addi   sp, sp, -16
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     ra, 12(sp)
    addi   sp, sp, -16
    sw     a0, 0(sp)
    sw     a1, 4(sp)
    sw     a2, 8(sp)
    sw     a3, 12(sp)

    mv     a1, t2
    mv     a2, s1
    li     a3, 4

    jal    fread

    li     a3, 4
    bne    a0, a3, wrong_91

    lw     a3, 12(sp)
    lw     a2, 8(sp)
    lw     a1, 4(sp)
    lw     a0, 0(sp)
    addi   sp, sp, 16
    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     ra, 12(sp)
    addi   sp, sp, 16

# read column
    addi   sp, sp, -16
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     ra, 12(sp)
    addi   sp, sp, -16
    sw     a0, 0(sp)
    sw     a1, 4(sp)
    sw     a2, 8(sp)
    sw     a3, 12(sp)

    mv     a1, t2
    mv     a2, s2
    li     a3, 4

    jal    fread

    li     a3, 4

    bne    a0, a3, wrong_91

    lw     a3, 12(sp)
    lw     a2, 8(sp)
    lw     a1, 4(sp)
    lw     a0, 0(sp)
    addi   sp, sp, 16
    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     ra, 12(sp)
    addi   sp, sp, 16



# 确定要读取的大小t1
    lw     t1, 0(s1)
    lw     t2, 0(s2)
    mul    t1, t1, t2
    slli   t1, t1, 2

# malloc
    mv     a0, t1

    addi   sp, sp, -16
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     ra, 12(sp)
    addi   sp, sp, -16
    sw     a0, 0(sp)
    sw     a1, 4(sp)
    sw     a2, 8(sp)
    sw     a3, 12(sp)

    jal    malloc

    beq    x0, a0, wrong_88

    mv     t3, a0           # get the address of memory


    lw     a3, 12(sp)
    lw     a2, 8(sp)
    lw     a1, 4(sp)
    lw     a0, 0(sp)
    addi   sp, sp, 16
    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     ra, 12(sp)
    addi   sp, sp, 16



# read

    mv     a1, s3
    mv     a2, t3
    mv     a3, t1

    addi   sp, sp, -20
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     t3, 12(sp)
    sw     ra, 16(sp)
    addi   sp, sp, -16
    sw     a0, 0(sp)
    sw     a1, 4(sp)
    sw     a2, 8(sp)
    sw     a3, 12(sp)

    jal    fread


    lw     a3, 12(sp)
    lw     a2, 8(sp)
    lw     a1, 4(sp)
    lw     a0, 0(sp)
    addi   sp, sp, 16
    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     t3, 12(sp)
    lw     ra, 16(sp)
    addi   sp, sp, 20

    bne    a0, t1, wrong_91

# close
    addi   sp, sp, -20
    sw     t0, 0(sp)
    sw     t1, 4(sp)
    sw     t2, 8(sp)
    sw     t3, 12(sp)
    sw     ra, 16(sp)
    addi   sp, sp, -16
    sw     a0, 0(sp)
    sw     a1, 4(sp)
    sw     a2, 8(sp)
    sw     a3, 12(sp)

    mv     a1, s3

    jal    fclose

    li     t0, -1
    beq    a0, t0, wrong_92


    lw     a3, 12(sp)
    lw     a2, 8(sp)
    lw     a1, 4(sp)
    lw     a0, 0(sp)
    addi   sp, sp, 16
    lw     t0, 0(sp)
    lw     t1, 4(sp)
    lw     t2, 8(sp)
    lw     t3, 12(sp)
    lw     ra, 16(sp)
    addi   sp, sp, 20


    mv     a0, t3


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




wrong_88:
    li     a1, 88
    jal    exit2

wrong_90:
    li     a1, 90
    jal    exit2

wrong_91:
    li     a1, 91
    jal    exit2

wrong_92:
    li     a1, 92
    jal    exit2