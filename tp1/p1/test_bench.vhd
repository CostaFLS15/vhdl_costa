library ieee;
use ieee.std_logic_1164.all;

entity p1_tb is
-- El testbench no tiene puertos, es una entidad "nube"
end entity p1_tb;

architecture sim of p1_tb is
    -- 1. Declarar señales para conectar con el componente (test)
    signal a_tb : std_logic := '0';
    signal b_tb : std_logic := '0';
    signal c_tb : std_logic := '0';
    signal z_tb : std_logic;

begin
    -- 2. Instanciar el componente (UUT: Unit Under Test)
    UUT: entity work.p1
        port map(
            a => a_tb,
            b => b_tb,
            c => c_tb,
            z => z_tb
        );

    -- 3. Proceso de estímulos
    process
    begin
        -- Probamos todas las combinaciones (8 casos para 3 entradas)
        -- Formato: a b c
        a_tb <= '0'; b_tb <= '0'; c_tb <= '0'; wait for 10 ns;
        a_tb <= '0'; b_tb <= '0'; c_tb <= '1'; wait for 10 ns;
        a_tb <= '0'; b_tb <= '1'; c_tb <= '0'; wait for 10 ns;
        a_tb <= '0'; b_tb <= '1'; c_tb <= '1'; wait for 10 ns;
        a_tb <= '1'; b_tb <= '0'; c_tb <= '0'; wait for 10 ns;
        a_tb <= '1'; b_tb <= '0'; c_tb <= '1'; wait for 10 ns;
        a_tb <= '1'; b_tb <= '1'; c_tb <= '0'; wait for 10 ns;
        a_tb <= '1'; b_tb <= '1'; c_tb <= '1'; wait for 10 ns;
        
        -- Fin de la simulación
        wait; 
    end process;

end architecture sim;