library ieee;
use ieee.std_logic_1164.all;
entity p1 is
    port(
        a : in std_logic;
        b : in std_logic;
        c : in std_logic;
        z : out std_logic
    );
end entity p1;
architecture rtl of p1 is
begin
    signal d: std_logic;
    signal e: std_logic;
    
    d<=a and b;
    e<=a and c;
    z <= d or e;
end architecture rtl;