    .globl matmul

    .text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# d = matmul(m0, m1)
# Arguments:
# a0 (int*) is the pointer to the start of m0
# a1 (int) is the # of rows (height) of m0
# a2 (int) is the # of columns (width) of m0
# a3 (int*) is the pointer to the start of m1
# a4 (int) is the # of rows (height) of m1
# a5 (int) is the # of columns (width) of m1
# a6 (int*) is the pointer to the the start of d
# Returns:
# None (void), sets d = matmul(m0, m1)
# Exceptions:
# Make sure to check in top to bottom order!
# - If the dimensions of m0 do not make sense,
# this function terminates the program with exit code 72.
# - If the dimensions of m1 do not make sense,
# this function terminates the program with exit code 73.
# - If the dimensions of m0 and m1 don't match,
# this function terminates the program with exit code 74.
# =======================================================
matmul:


# Prologue
    addi   sp, sp, -32
    sw     s0, 0(sp)
    sw     s1, 4(sp)
    sw     s2, 8(sp)
    sw     s3, 12(sp)
    sw     s4, 16(sp)
    sw     s5, 20(sp)
    sw     s6, 24(sp)
    sw     s7, 28(sp)


# Error checking
    li     t0, 1
    blt    a1, t0, wrong_72
    blt    a2, t0, wrong_72
    blt    a4, t0, wrong_73
    blt    a5, t0, wrong_73
    bne    a2, a4, wrong_74

#初始化
    mv     s0, a0
    mv     s1, a1
    mv     s2, a2
    mv     s3, a3
    mv     s4, a4
    mv     s5, a5
    mv     s6, a6
    li     s7 ,0

    li     t0, 0                  # t0 = x从0~s1-1 X=(t0,0)
    li     t1, 0                  # t1 = y从0~s5-1 Y=(0,t1)
    mv     a5, s0                 # a5作为迭代器找第一个矩阵的(t0,0)的位置
    mv     a6, s3                 # a6作为迭代器找第二个矩阵的(0,t1)的位置
    li     a3, 1                  # 步长1
    mv     a4, s5                 # 步长s5
    mv     a2, s4
    mv     t3, s0                 # t3用来移动的索引
    mv     t4, s3                 # t4用来移动的索引



outer_loop_start:
    beq    t0, s1, outer_loop_end  





inner_loop_start:
    beq    t1, s5, inner_loop_end   # t1走完了，说明前一个矩阵的一行完了，到下一行

    mv     a0, t3
    mv     a1, t4
    mv     a2, s4
    li     a3, 1                  # 步长1
    mv     a4, s5                 # 步长s5


    addi   sp, sp, -20
    sw     ra, 0(sp)
    sw     t0, 4(sp)
    sw     t1, 8(sp)
    sw     t3, 12(sp)
    sw     t4, 16(sp)

    jal    dot

    lw     ra, 0(sp)
    lw     t0, 4(sp)
    lw     t1, 8(sp)
    lw     t3, 12(sp)
    lw     t4, 16(sp)
    addi   sp, sp, 20

    mv     s7, a0
    sw     s7, 0(s6)



    addi   t1, t1, 1
    addi   t4, t4, 4              # t4向右移一格
    addi   s6, s6, 4
    j      inner_loop_start


inner_loop_end:
    li     t1, 0
    li     t5, 4
    mv     t6, s2
    mul    t6, t6, t5
    add    t3, t3, t6             # t3向下移一格
    mv     t4, s3                 # t4 复位到左上角
    addi   t0, t0, 1
    j      outer_loop_start


outer_loop_end:
# Epilogue
    lw     s0, 0(sp)
    lw     s1, 4(sp)
    lw     s2, 8(sp)
    lw     s3, 12(sp)
    lw     s4, 16(sp)
    lw     s5, 20(sp)
    lw     s6, 24(sp)
    lw     s7, 28(sp)
    addi   sp, sp, 32


    ret


wrong_72:
    li     a1, 72
    jal    exit2

wrong_73:
    li     a1, 73
    jal    exit2

wrong_74:
    li     a1, 74
    jal    exit2
