library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity p3 is
    generic(
        validar_votos: integer : 50;
    );
    port(
        A: in std_logic;
        B: in std_logic;
        C: in std_logic;
        D: in std_logic;
        reset: in std_logic;
        segmentos : out std_logic_vector (6 downto 0);
        display: out std_logic
    );
end entity p3;
architecture rtl of p3 is
    signal votos : std_logic_vector(3 downto 0);
    signal seg_int : std_logic_vector(6 downto 0);
begin
   display <= '1' when reset = '0' else '0';
   votos <= A & B & C & D;
   with votos select
        seg_int <= "0001000" when "0011" | "0101" | "0111" | "1001" | "1011" | "1101" | "1110" | "1111", -- Letra "A" (Aprobado)
                   "1000010" when others;
    segmentos <= "1111111" when reset = '0' else seg_int;
                
end architecture rtl;