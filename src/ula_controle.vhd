library ieee;
use ieee.std_logic_1164.all;

entity ula_controle is
    port (
        ALUOp       :   in std_logic_vector(2 downto 0);
        funct7      :   in std_logic_vector(6 downto 0);
        funct3      :   in std_logic_vector (2 downto 0);
        ALUControl  :   out std_logic_vector (3 downto 0)
    );
end entity ula_controle;

architecture rtl of ula_controle is
begin
    process(ALUOp, funct7, funct3)
    begin
        case ALUOp is
            when "000" =>
                ALUControl <= "0010";
            when "001" =>
                ALUControl <= "0110";
            when "100" =>
                ALUControl <= "1111";
            when others =>
                case funct3 is
                    when "000" =>
                        if ALUOp = "010" and funct7(5) = '1' then
                            ALUControl <= "0110";
                        else
                            ALUControl <= "0010";
                        end if;
                    when "111" =>
                        ALUControl <= "0000";
                    when "110" =>
                        ALUControl <= "0001";
                    when "100" =>
                        ALUControl <= "0011";
                    when "010" =>
                        ALUControl <= "0111";
                    when others =>
                        ALUControl <= "0010";
                end case;
        end case;
    end process;
end architecture rtl;
