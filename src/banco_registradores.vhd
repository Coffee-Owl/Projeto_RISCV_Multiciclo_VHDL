library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tipos.all;

entity banco_registradores is
    port (
        clk         : in std_logic;
        EscreveReg  : in std_logic;
        rs1         : in std_logic_vector(4 downto 0);
        rs2         : in std_logic_vector(4 downto 0);
        rd          : in std_logic_vector(4 downto 0);
        DadoEscrita : in std_logic_vector(31 downto 0);
        Dado1       : out std_logic_vector(31 downto 0);
        Dado2       : out std_logic_vector(31 downto 0)
    );
end entity banco_registradores;

architecture rtl of banco_registradores is
    signal regs : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if EscreveReg = '1' and rd /= "00000" then
                regs(to_integer(unsigned(rd))) <= DadoEscrita;
            end if;
        end if;
    end process;

    Dado1 <= regs(to_integer(unsigned(rs1)));
    Dado2 <= regs(to_integer(unsigned(rs2)));
end architecture rtl;
