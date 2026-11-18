library ieee;
use ieee.std_logic_1164.all;

entity controle is
    port (
        clk            : in std_logic;
        rst            : in std_logic;
        opcode         : in std_logic_vector(6 downto 0);
        EscrevePCCond  : out std_logic;
        EscrevePC      : out std_logic;
        IouD           : out std_logic;
        EscreveMem     : out std_logic;
        LeMem          : out std_logic;
        EscreveIR      : out std_logic;
        OrigPC         : out std_logic;
        ALUOp          : out std_logic_vector(2 downto 0);
        OrigAULA       : out std_logic_vector(1 downto 0);
        OrigBULA       : out std_logic_vector(1 downto 0);
        EscrevePCB     : out std_logic;
        EscreveReg     : out std_logic;
        Mem2Reg        : out std_logic_vector(1 downto 0)
    );
end entity controle;

architecture rtl of controle is
    type estado_t is (
        BUSCA, DECODIFICA, CALC_END, LE_MEM, ESCREVE_REG_MEM, ESCREVE_MEM,
        EXEC_R, EXEC_I, EXEC_AUIPC, EXEC_LUI, ESCREVE_REG_ULA,
        DESVIO, EXEC_JAL, EXEC_JALR
    );
    signal estado, proximo : estado_t;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            estado <= BUSCA;
        elsif rising_edge(clk) then
            estado <= proximo;
        end if;
    end process;

    process(estado, opcode)
    begin
        proximo <= BUSCA;
        case estado is
            when BUSCA =>
                proximo <= DECODIFICA;
            when DECODIFICA =>
                case opcode is
                    when "0000011" | "0100011" => proximo <= CALC_END;
                    when "0110011" => proximo <= EXEC_R;
                    when "0010011" => proximo <= EXEC_I;
                    when "0010111" => proximo <= EXEC_AUIPC;
                    when "0110111" => proximo <= EXEC_LUI;
                    when "1100011" => proximo <= DESVIO;
                    when "1101111" => proximo <= EXEC_JAL;
                    when "1100111" => proximo <= EXEC_JALR;
                    when others    => proximo <= BUSCA;
                end case;
            when CALC_END =>
                if opcode = "0000011" then
                    proximo <= LE_MEM;
                else
                    proximo <= ESCREVE_MEM;
                end if;
            when LE_MEM =>
                proximo <= ESCREVE_REG_MEM;
            when EXEC_R | EXEC_I | EXEC_AUIPC | EXEC_LUI =>
                proximo <= ESCREVE_REG_ULA;
            when others =>
                proximo <= BUSCA;
        end case;
    end process;

    process(estado)
    begin
        EscrevePCCond <= '0';
        EscrevePC     <= '0';
        IouD          <= '0';
        EscreveMem    <= '0';
        LeMem         <= '0';
        EscreveIR     <= '0';
        OrigPC        <= '0';
        ALUOp         <= "000";
        OrigAULA      <= "00";
        OrigBULA      <= "00";
        EscrevePCB    <= '0';
        EscreveReg    <= '0';
        Mem2Reg       <= "00";
        case estado is
            when BUSCA =>
                LeMem      <= '1';
                EscreveIR  <= '1';
                OrigAULA   <= "10";
                OrigBULA   <= "01";
                EscrevePC  <= '1';
                EscrevePCB <= '1';
            when DECODIFICA =>
                OrigAULA <= "00";
                OrigBULA <= "11";
            when CALC_END =>
                OrigAULA <= "01";
                OrigBULA <= "10";
            when LE_MEM =>
                IouD  <= '1';
                LeMem <= '1';
            when ESCREVE_REG_MEM =>
                Mem2Reg    <= "10";
                EscreveReg <= '1';
            when ESCREVE_MEM =>
                IouD       <= '1';
                EscreveMem <= '1';
            when EXEC_R =>
                OrigAULA <= "01";
                OrigBULA <= "00";
                ALUOp    <= "010";
            when EXEC_I =>
                OrigAULA <= "01";
                OrigBULA <= "10";
                ALUOp    <= "011";
            when EXEC_AUIPC =>
                OrigAULA <= "00";
                OrigBULA <= "10";
            when EXEC_LUI =>
                OrigBULA <= "10";
                ALUOp    <= "100";
            when ESCREVE_REG_ULA =>
                Mem2Reg    <= "00";
                EscreveReg <= '1';
            when DESVIO =>
                OrigAULA      <= "01";
                OrigBULA      <= "00";
                ALUOp         <= "001";
                OrigPC        <= '1';
                EscrevePCCond <= '1';
            when EXEC_JAL =>
                OrigPC     <= '1';
                EscrevePC  <= '1';
                Mem2Reg    <= "01";
                EscreveReg <= '1';
            when EXEC_JALR =>
                OrigAULA   <= "01";
                OrigBULA   <= "10";
                OrigPC     <= '0';
                EscrevePC  <= '1';
                Mem2Reg    <= "01";
                EscreveReg <= '1';
        end case;
    end process;
end architecture rtl;
