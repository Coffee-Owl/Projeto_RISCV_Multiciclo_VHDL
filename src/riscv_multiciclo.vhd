library ieee;
use ieee.std_logic_1164.all;

entity riscv_multiciclo is
    generic (
        ARQ_CODIGO : string := "programas/code.txt";
        ARQ_DADOS  : string := "programas/data.txt"
    );
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity riscv_multiciclo;

architecture rtl of riscv_multiciclo is
    signal EscrevePCCond, EscrevePC, IouD, EscreveMem, LeMem, EscreveIR : std_logic;
    signal OrigPC, EscrevePCB, EscreveReg : std_logic;
    signal ALUOp : std_logic_vector(2 downto 0);
    signal OrigAULA, OrigBULA, Mem2Reg : std_logic_vector(1 downto 0);
    signal ALUControl : std_logic_vector(3 downto 0);

    signal pc, pc_prox, pcback, endereco, dado_mem, ir, mdr : std_logic_vector(31 downto 0);
    signal dado_escrita, dado1, dado2, a, b : std_logic_vector(31 downto 0);
    signal imm, imm_desl, ula_a, ula_b, ula_res, saida_ula : std_logic_vector(31 downto 0);
    signal zero, condicao, escreve_pc : std_logic;
begin
    ctrl: entity work.controle
        port map (
            clk => clk, rst => rst, opcode => ir(6 downto 0),
            EscrevePCCond => EscrevePCCond, EscrevePC => EscrevePC, IouD => IouD,
            EscreveMem => EscreveMem, LeMem => LeMem, EscreveIR => EscreveIR,
            OrigPC => OrigPC, ALUOp => ALUOp, OrigAULA => OrigAULA, OrigBULA => OrigBULA,
            EscrevePCB => EscrevePCB, EscreveReg => EscreveReg, Mem2Reg => Mem2Reg
        );

    condicao   <= zero xor ir(12);
    escreve_pc <= EscrevePC or (EscrevePCCond and condicao);
    pc_prox    <= ula_res(31 downto 1) & '0' when OrigPC = '0' else saida_ula;

    reg_pc: entity work.registrador
        port map (clk => clk, rst => rst, en => escreve_pc, d => pc_prox, q => pc);

    reg_pcback: entity work.registrador
        port map (clk => clk, rst => rst, en => EscrevePCB, d => pc, q => pcback);

    endereco <= pc when IouD = '0' else saida_ula;

    mem: entity work.memoria
        generic map (ARQ_CODIGO => ARQ_CODIGO, ARQ_DADOS => ARQ_DADOS)
        port map (
            clk => clk, EscreveMem => EscreveMem, LeMem => LeMem,
            Endereco => endereco, DadoEscrita => b, DadoLido => dado_mem
        );

    reg_ir: entity work.registrador
        port map (clk => clk, rst => rst, en => EscreveIR, d => dado_mem, q => ir);

    reg_mdr: entity work.registrador
        port map (clk => clk, rst => rst, en => '1', d => dado_mem, q => mdr);

    with Mem2Reg select
        dado_escrita <= saida_ula when "00",
                        pc        when "01",
                        mdr       when others;

    banco: entity work.banco_registradores
        port map (
            clk => clk, EscreveReg => EscreveReg,
            rs1 => ir(19 downto 15), rs2 => ir(24 downto 20), rd => ir(11 downto 7),
            DadoEscrita => dado_escrita, Dado1 => dado1, Dado2 => dado2
        );

    reg_a: entity work.registrador
        port map (clk => clk, rst => rst, en => '1', d => dado1, q => a);

    reg_b: entity work.registrador
        port map (clk => clk, rst => rst, en => '1', d => dado2, q => b);

    gerador: entity work.imm_gen
        port map (instr => ir, imm_out => imm);

    imm_desl <= imm(30 downto 0) & '0';

    with OrigAULA select
        ula_a <= pcback when "00",
                 a      when "01",
                 pc     when others;

    with OrigBULA select
        ula_b <= b          when "00",
                 x"00000004" when "01",
                 imm        when "10",
                 imm_desl   when others;

    ctrl_ula: entity work.ula_controle
        port map (
            ALUOp => ALUOp, funct7 => ir(31 downto 25), funct3 => ir(14 downto 12),
            ALUControl => ALUControl
        );

    alu: entity work.ula
        port map (A => ula_a, B => ula_b, ALUControl => ALUControl, Resultado => ula_res, Zero => zero);

    reg_saida_ula: entity work.registrador
        port map (clk => clk, rst => rst, en => '1', d => ula_res, q => saida_ula);
end architecture rtl;
