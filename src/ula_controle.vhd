library ieee;   
use ieee.std_logic_1164.all;

entity ula_controle is
    port (
        ALUOp       :   in std_logic_vector(1 downto 0);
        funct7      :   in std_logic_vector(6 downto 0);
        funct3      :   in std_logic_vector (2 downto 0);
        ALUControl  :   out std_logic_vector (3 downto 0)
    );
end entity ula_controle;