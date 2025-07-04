.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    li t0, 1
    blt a1, t0, wrong
    li t1, 0

    mv s0, a0
    mv s1, a1
    

loop_start:
    beq t1, s1, loop_end
    lw t2, 0(s0) 
    bge t2 , zero, loop_continue
    sw zero, 0(s0)

loop_continue:

    addi s0, s0, 4
    addi t1, t1, 1 
    j loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    
	ret


wrong:
    li a1, 78
    jal exit2
