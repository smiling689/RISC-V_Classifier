    .globl dot

    .text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
# a0 (int*) is the pointer to the start of v0
# a1 (int*) is the pointer to the start of v1
# a2 (int) is the length of the vectors
# a3 (int) is the stride of v0
# a4 (int) is the stride of v1
# Returns:
# a0 (int) is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
# this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
# this function terminates the program with error code 76.
# =======================================================
dot:
# Prologue
    addi   sp, sp, -28
    sw     s0, 0(sp)
    sw     s1, 4(sp)
    sw     s2, 8(sp)
    sw     s3, 12(sp)
    sw     s4, 16(sp)
    sw     s5, 20(sp)
    sw     s6, 24(sp)

    li     t0, 1            # 作为参数，不保留下来，每次使用前初始化
    blt    a2, t0, wrong_75
    blt    a3, t0, wrong_76
    blt    a4, t0, wrong_76

#初始化
    mv     s0, a0           # s0->第一个数组地址
    mv     s1, a1           # s1->第二个数组地址
    mv     s2, a2           # s2->长度
    mv     s3, a3           # s3->第一个数组步长
    mv     s4, a4           # s4->第二个数组步长

# 步长修改
    li     t0, 4
    mul    s5, s3, t0
    mul    s6, s4, t0

    li     a0, 0            # dot答案
    li     a2, 0            # a2->计数器

loop_start:
    bge    a2, s2, loop_end
    lw     t1, 0(s0)
    lw     t2, 0(s1)
    mul    a1, t1, t2
    add    a0, a0, a1

loop_continue:

    add    s0, s0, s5
    add    s1, s1, s6
    addi   a2, a2, 1
    j      loop_start

loop_end:
# Epilogue
    lw     s0, 0(sp)
    lw     s1, 4(sp)
    lw     s2, 8(sp)
    lw     s3, 12(sp)
    lw     s4, 16(sp)
    lw     s5, 20(sp)
    lw     s6, 24(sp)
    addi   sp, sp, 28

    ret


wrong_75:
    li     a1, 75
    jal    exit2

wrong_76:
    li     a1, 76
    jal    exit2
