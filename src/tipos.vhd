library ieee;
use ieee.std_logic_1164.all;

package tipos is
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    type mem_array is array (0 to 4095) of std_logic_vector(31 downto 0);
end package tipos;
