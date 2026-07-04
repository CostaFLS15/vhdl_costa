library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p2 is
    generic(
        cnt_MAX : integer := 50000000 -- Para simular un reloj de 1Hz a partir de 50MHz
    );
    port(
        clk       : in std_logic;
        reset     : in std_logic; -- Reset asincrónico (activo en '0')
        start     : in std_logic; -- Botón de inicio (activo en '0')
        leds      : out std_logic_vector (1 downto 0); -- led(1)=UV, led(0)=Rojo
        segmentos : out std_logic_vector (6 downto 0);
        display   : out std_logic
    );
end entity p2;

architecture rtl of p2 is
    -- Declaraciones de Tipos y Señales (ANTES del begin)
    type t_estado is (REPOSO, ESTERILIZANDO, FINALIZADO);
    signal estado : t_estado := REPOSO;

    signal cnt      : integer range 0 to cnt_MAX - 1 := 0;
    signal tick_1s  : std_logic := '0';
    signal T_UV     : integer range 0 to 9 := 0;
begin

    -- 1. DIVISOR DE FRECUENCIA (Genera un pulso 'tick_1s' cada 1 segundo)
    process(clk, reset)
    begin
        if reset = '0' then
            cnt     <= 0;
            tick_1s <= '0';
        elsif rising_edge(clk) then
            if estado = ESTERILIZANDO then  -- Solo cuenta si estamos esterilizando
                if cnt = cnt_MAX - 1 then
                    cnt     <= 0;
                    tick_1s <= '1'; -- Genera un pulso que dura un ciclo de reloj
                else
                    cnt     <= cnt + 1;
                    tick_1s <= '0';
                end if;
            else
                cnt     <= 0;
                tick_1s <= '0';
            end if;
        end if;
    end process;

    -- 2. MÁQUINA DE ESTADOS SECUENCIAL (Controla el proceso y los segundos)
    process(clk, reset)
    begin
        if reset = '0' then
            estado <= REPOSO;
            T_UV   <= 0;
            leds   <= "00";
        elsif rising_edge(clk) then
            case estado is
                when REPOSO =>
                    leds <= "00"; -- Todo apagado
                    T_UV <= 0;
                    if start = '0' then -- Si presionan START (activo bajo)
                        estado <= ESTERILIZANDO;
                    end if;

                when ESTERILIZANDO =>
                    leds <= "10"; -- led(1) = '1' (UV Encendido), led(0) = '0'
                    if tick_1s = '1' then
                        if T_UV = 9 then
                            estado <= FINALIZADO;
                        else
                            T_UV <= T_UV + 1;
                        end if;
                    end if;

                when FINALIZADO =>
                    leds <= "01"; -- led(1) = '0' (UV Apagado), led(0) = '1' (Rojo Encendido)
                    if start = '0' then -- Un nuevo start reinicia el proceso
                        estado <= REPOSO;
                    end if;

                when others =>
                    estado <= REPOSO;
            end case;
        end if;
    end process;

    -- 3. HABILITACIÓN DEL DISPLAY (Siempre encendido)
    display <= '0'; 

    -- 4. DECODIFICADOR 7 SEGMENTOS (Fuera del proceso, usando WITH SELECT)
    with T_UV select
        segmentos <= "0000001" when 0, -- 0
                     "1001111" when 1, -- 1
                     "0010011" when 2, -- 2
                     "0000110" when 3, -- 3
                     "1001100" when 4, -- 4
                     "0100100" when 5, -- 5
                     "0100000" when 6, -- 6
                     "0001111" when 7, -- 7
                     "0000000" when 8, -- 8
                     "0000100" when 9, -- 9
                     "1111111" when others;

end architecture rtl;