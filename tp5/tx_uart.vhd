library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
entity tx_uart is
	port
	(
		clk,reset,enable: in  std_logic:='0';
		send : in std_logic;
		cadena : in std_LOGIC_VECTOR(7 dowNTO 0);		
		tx, done : out std_logic:='0'
	);
end tx_uart;
architecture a_t_uart of tx_uart is

type mef is (idle, start, d0,d1,d2,d3,d4,d5,d6,d7,stop);
signal clkss,clkis,rst1s : std_logic:='0';
signal ds: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal estado:mef;
signal cnt : integer range 0 to 20 := 1;
Begin



--inst_cont: entity work.conta generic map (0,434 ) 	port map( clk=>clk, reset=>'0', enable=>'1', cout=>clkis, q=>open);


	process(clk,reset)
	begin
		if send='1' then estado<=idle; done <= '0';
		else
			ds <= cadena;-- TRANSFORMO CADA ELEMENTO DEL STRING
			
			if send='1' then estado<=idle; 
			elsif rising_edge(clk) then	
				case estado is 
					when idle => 
						 estado<=start; 
					when start => 
						 estado<=d0;
					when d0 => 
						 estado<=d1;
					when d1 => 
						 estado<=d2;
					when d2 => 
						 estado<=d3;
					when d3 => 
						estado<=d4;
					when d4 => 
						estado<=d5;
					when d5 => 
						estado<=d6;
					when d6 => 
						estado<=d7;
					when d7 => estado<=stop; 
					when stop => 
						estado<=idle; done <= '1'; 						
					end case;
			end if;
		end if;
	end process;
	
	
	process (estado,ds)
	Begin
			case estado is 
				when idle => tx<='1'; 
				when start => tx<='0';
				when d0 => tx<=ds(0);
				when d1 => tx<=ds(1);
				when d2 => tx<=ds(2);
				when d3 => tx<=ds(3);
				when d4 => tx<=ds(4);
				when d5 => tx<=ds(5);
				when d6 => tx<=ds(6);
				when d7 => tx<=ds(7);
				when stop => tx<='0'; 
			end case;
	end process;
end a_t_uart;