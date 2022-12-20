.text

addi a0, x0, 1
addi x12, x0, 5
add x13, x12, x0

fat:
beq x12, x10, fim
addi x12, x12, -1
mul x13, x12, x13

j fat

fim:
add x11, x0, x13
ecall