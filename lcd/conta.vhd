library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity conta is
	generic	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 256	);

	port	(
		clk		  : in std_logic;
		reset	  : in std_logic;
		enable	  : in std_logic;
		cout: out std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT	);
end entity;
architecture rtl of conta is
begin
	process (clk)
		variable   cnt: integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then
			if reset = '0' then
				cnt := 0;
			elsif enable = '1' then cnt := cnt + 1;
				if cnt< max_count/2 then cout<='0';
				else cout<='1';
				end iF;
				if cnt=MAX_COUNT then cnt:=0; end if;
			end if;
		end if;
		q <= cnt;
		--if cnt=MAX_COUNT then cnt:=0; end if;
	end process;
end rtl;
