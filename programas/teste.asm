.data
valores: .word 10, 20, 30

.text
	lui   x1, 2
	lw    x2, 0(x1)
	lw    x3, 4(x1)
	lw    x4, 8(x1)
	add   x5, x2, x3
	sub   x6, x3, x2
	sub   x7, x2, x3
	and   x8, x2, x3
	or    x9, x2, x3
	xor   x10, x4, x3
	slt   x11, x2, x3
	slt   x12, x3, x2
	addi  x13, x0, -1
	slt   x14, x13, x2
	addi  x15, x2, -1024
	addi  x0, x0, 5
	sw    x5, 12(x1)
	lw    x16, 12(x1)
	auipc x17, 0
	beq   x2, x6, pula1
	addi  x18, x0, 1
pula1:
	bne   x2, x3, pula2
	addi  x18, x0, 2
pula2:
	beq   x2, x3, erro
	bne   x2, x6, erro
	addi  x19, x0, 0
	addi  x20, x0, 5
laco:
	add   x19, x19, x20
	addi  x20, x20, -1
	bne   x20, x0, laco
	jal   x21, funcao
	sw    x22, 16(x1)
	lui   x23, 0x12345
	addi  x23, x23, 0x678
fim:
	jal   x0, fim
erro:
	addi  x24, x0, 1
	jal   x0, fim
funcao:
	addi  x22, x0, 77
	jalr  x0, 0(x21)
