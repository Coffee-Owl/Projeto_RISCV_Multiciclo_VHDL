library ieee;
use ieee.std_logic_1164.all;

entity imm_gen is
    port (
        instr   : in std_logic_vector(31 downto 0);
        imm_out : out std_logic_vector(31 downto 0)
    );
end entity imm_gen;

architecture rtl of imm_gen is
begin
    process(instr)
    begin
        case instr(6 downto 0) is
            when "0010011" | "0000011" | "1100111" => -- Tipo I
                imm_out <= (19 downto 0 => instr(31)) & instr(31 downto 20);
            when "0110111" | "0010111" => -- Tipo U
                imm_out <= instr(31 downto 12) & (11 downto 0 => '0');
            when "0100011" => -- Tipo S
                imm_out <= (19 downto 0 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            when "1100011" => -- Tipo B
                imm_out <= (19 downto 0 => instr(31)) & instr(31) & instr(7) &
                 instr(30 downto 25) & instr(11 downto 8);
            when "1101111" => -- Tipo J
                imm_out <= (11 downto 0 => instr(31)) & instr(31) & instr(19 downto 12) &
                 instr(20) & instr(30 downto 21);
            when others =>
                imm_out <= (others => '0');
        end case;
    end process;
end architecture rtl;