vlib work
vcom -2008 src/tipos.vhd src/registrador.vhd src/banco_registradores.vhd src/memoria.vhd src/imm_gen.vhd src/ula.vhd src/ula_controle.vhd src/controle.vhd src/riscv_multiciclo.vhd tb/tb_riscv.vhd
vsim tb_riscv
run -all
