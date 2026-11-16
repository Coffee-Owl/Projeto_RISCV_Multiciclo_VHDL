library ieee;
use ieee.std_logic_1164.all;    
use ieee.numeric_std.all;

entity ula is
    port (
        A           : in std_logic_vector(31 downto 0);
        B           : in std_logic_vector(31 downto 0);
        ALUControl  : in std_logic_vector(3 downto 0);
        Resultado   : out std_logic_vector(31 downto 0);
        Zero        : out std_logic 
    );
end entity ula;

architecture rtl of ula is
    signal res : std_logic_vector(31 downto 0);
begin
    process (A, B, ALUControl)
    begin
        case ALUControl is
            when "0010" =>
                res <= std_logic_vector(signed(A) + signed(B));
            when "0110" =>
                res <= std_logic_vector(signed(A) - signed(B));
            when "0000" =>
                res <= A and B;
            when "0001" =>
                res <= A or B;
            when "0011" =>
                res <= A xor B;
            when "0111" =>
                if signed(A) < signed(B) then
                    res <= x"00000001";
                else
                    res <= x"00000000";
                end if;
            when "1111" =>
                res <= B;
            when others =>
                res <= (others => '0');
        end case;
    end process;

    Resultado <= res;
    Zero <= '1' when res = x"00000000" else '0';
end architecture;