library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.tipos.all;

entity memoria is
    generic (
        ARQ_CODIGO : string := "programas/code.txt";
        ARQ_DADOS  : string := "programas/data.txt"
    );
    port (
        clk         : in std_logic;
        EscreveMem  : in std_logic;
        LeMem       : in std_logic;
        Endereco    : in std_logic_vector(31 downto 0);
        DadoEscrita : in std_logic_vector(31 downto 0);
        DadoLido    : out std_logic_vector(31 downto 0)
    );
end entity memoria;

architecture rtl of memoria is
    impure function carrega return mem_array is
        variable m      : mem_array := (others => (others => '0'));
        file arq        : text;
        variable estado : file_open_status;
        variable linha  : line;
        variable palavra: std_logic_vector(31 downto 0);
        variable i      : integer;
    begin
        file_open(estado, arq, ARQ_CODIGO, read_mode);
        if estado = open_ok then
            i := 0;
            while not endfile(arq) and i < 2048 loop
                readline(arq, linha);
                if linha'length > 0 then
                    hread(linha, palavra);
                    m(i) := palavra;
                    i := i + 1;
                end if;
            end loop;
            file_close(arq);
        end if;
        file_open(estado, arq, ARQ_DADOS, read_mode);
        if estado = open_ok then
            i := 2048;
            while not endfile(arq) and i < 4096 loop
                readline(arq, linha);
                if linha'length > 0 then
                    hread(linha, palavra);
                    m(i) := palavra;
                    i := i + 1;
                end if;
            end loop;
            file_close(arq);
        end if;
        return m;
    end function;

    signal mem : mem_array := carrega;
    signal pos : integer range 0 to 4095;
begin
    pos <= to_integer(unsigned(Endereco(13 downto 2)));

    process(clk)
    begin
        if rising_edge(clk) then
            if EscreveMem = '1' then
                mem(pos) <= DadoEscrita;
            end if;
        end if;
    end process;

    DadoLido <= mem(pos) when LeMem = '1' else (others => '0');
end architecture rtl;
