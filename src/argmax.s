.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    li t0, 1
    blt a1, t0, wrong
    li t1, 0

    mv s0, a0
    mv s1, a1

    lw t2, 0(s0)
    mv a2, t2 # a2 是最大值
    mv a3, zero # a3 是最大值索引
    

loop_start:
    beq t1, s1, loop_end
    lw t2, 0(s0) 
    bge a2 , t2, loop_continue
    mv a2, t2
    mv a3, t1

loop_continue:

    addi s0, s0, 4
    addi t1, t1, 1 
    j loop_start

loop_end:

    mv a0, a3
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    
	ret


wrong:
    li a1, 77
    jal exit2
