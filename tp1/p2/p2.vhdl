library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity p2 is
    generic(
        cnt_max: integer : 50000000;
    );
    port(
        clk : in std_logic;--50MHz
        clk_out : in std_logic; --1hz
        reset : in std_logic;
        clk_out : out std_logic;
        LED : out std_logic
    );
end entity p2;
architecture rtl of p2 is
begin
    process (clk, reset)
        variable cnt: integer range 0 to cnt_max;
    begin
        if reset='0' then
            cnt=0;
            clk_out='0';
            led<='1';
        else rise_edge(clk) then
            cnt=cnt+1;
            if cnt<cnt_max/2 then
                clk_out<='1';
            elsif cnt>cnt_max then
                clk_out<='0';
            elsif cnt=cnt_max then
                cnt=0;
                clk_out<='0'
            end if;
        end if;
    end process;

end architecture rtl;