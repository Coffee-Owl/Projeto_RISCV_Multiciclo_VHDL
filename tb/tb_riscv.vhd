library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tipos.all;

entity tb_riscv is
end entity tb_riscv;

architecture sim of tb_riscv is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal rodando : boolean := true;
begin
    dut: entity work.riscv_multiciclo
        generic map (ARQ_CODIGO => "programas/code.txt", ARQ_DADOS => "programas/data.txt")
        port map (clk => clk, rst => rst);

    clk <= not clk after 5 ns when rodando;

    process
        alias regs is << signal .tb_riscv.dut.banco.regs : reg_array >>;
        alias mem  is << signal .tb_riscv.dut.mem.mem : mem_array >>;
        variable erros : integer := 0;

        procedure confere(nome : string; obtido : std_logic_vector(31 downto 0); esperado : integer) is
        begin
            if obtido /= std_logic_vector(to_signed(esperado, 32)) then
                report nome & " = " & integer'image(to_integer(signed(obtido))) &
                       ", esperado " & integer'image(esperado) severity error;
                erros := erros + 1;
            end if;
        end procedure;
    begin
        wait for 12 ns;
        rst <= '0';
        wait for 3 us;

        confere("x0",  regs(0),  0);
        confere("x1",  regs(1),  16#2000#);
        confere("x2",  regs(2),  10);
        confere("x3",  regs(3),  20);
        confere("x4",  regs(4),  30);
        confere("x5",  regs(5),  30);
        confere("x6",  regs(6),  10);
        confere("x7",  regs(7),  -10);
        confere("x8",  regs(8),  0);
        confere("x9",  regs(9),  30);
        confere("x10", regs(10), 10);
        confere("x11", regs(11), 1);
        confere("x12", regs(12), 0);
        confere("x13", regs(13), -1);
        confere("x14", regs(14), 1);
        confere("x15", regs(15), -1014);
        confere("x16", regs(16), 30);
        confere("x17", regs(17), 16#48#);
        confere("x18", regs(18), 0);
        confere("x19", regs(19), 15);
        confere("x20", regs(20), 0);
        confere("x21", regs(21), 16#7C#);
        confere("x22", regs(22), 77);
        confere("x23", regs(23), 16#12345678#);
        confere("x24", regs(24), 0);
        confere("mem[0x200C]", mem(16#200C# / 4), 30);
        confere("mem[0x2010]", mem(16#2010# / 4), 77);

        if erros = 0 then
            report "TESTE OK: todos os valores conferem" severity note;
        else
            report "TESTE FALHOU: " & integer'image(erros) & " valores errados" severity error;
        end if;
        rodando <= false;
        wait;
    end process;
end architecture sim;
