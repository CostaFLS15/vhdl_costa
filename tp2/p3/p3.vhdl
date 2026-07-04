library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p4 is
    generic(
        -- 50MHz / 400Hz = 125000 ciclos de reloj
        CLK_FREQ_DIV : integer := 125000 
    );
    port(
        clk       : in  std_logic; -- Reloj de 50 MHz de la placa Altera
        reset     : in  std_logic; -- Reset asincrónico (activo bajo '0')
        segmentos : out std_logic_vector(6 downto 0); -- Bus común de segmentos (A a G)
        anodos    : out std_logic_vector(3 downto 0)  -- Activadores de los 4 displays
    );
end entity p4;

architecture rtl of p4 is
    -- Definición de los estados para la MEF (un estado por display)
    type t_estado is (DSP0, DSP1, DSP2, DSP3);
    signal estado_pres, estado_sig : t_estado;

    -- Divisor de frecuencia para lograr los 400 Hz
    signal cnt       : integer range 0 to CLK_FREQ_DIV - 1 := 0;
    signal tick_400hz : std_logic := '0';

    -- Señal interna para almacenar el dígito BCD (0 a 9) actual a mostrar
    signal digito_actual : integer range 0 to 9;

begin

    -- 1. DIVISOR DE FRECUENCIA (Genera un pulso 'tick' a 400 Hz)
    process(clk, reset)
    begin
        if reset = '0' then
            cnt        <= 0;
            tick_400hz <= '0';
        elsif rising_edge(clk) then
            if cnt = CLK_FREQ_DIV - 1 then
                cnt        <= 0;
                tick_400hz <= '1'; -- Pulso activo por un ciclo de reloj
            else
                cnt        <= cnt + 1;
                tick_400hz <= '0';
            end if;
        end if;
    end process;

    -- 2. MÁQUINA DE ESTADOS: Registro de Estado (Secuencial)
    process(clk, reset)
    begin
        if reset = '0' then
            estado_pres <= DSP0;
        elsif rising_edge(clk) then
            if tick_400hz = '1' then
                estado_pres <= estado_sig; -- Cambia de estado a velocidad de 400Hz
            end if;
        end if;
    end process;

    -- 3. MÁQUINA DE ESTADOS: Lógica de Transición y Salidas (Combinacional)
    process(estado_pres)
    begin
        case estado_pres is
            when DSP0 =>
                anodos        <= "1110"; -- Enciende Display 0 (Lógica invertida de Altera)
                digito_actual <= 1;      -- Número que queremos mostrar en el Display 0
                estado_sig    <= DSP1;   -- Siguiente display

            when DSP1 =>
                anodos        <= "1101"; -- Enciende Display 1
                digito_actual <= 2;      -- Número que queremos mostrar en el Display 1
                estado_sig    <= DSP2;

            when DSP2 =>
                anodos        <= "1011"; -- Enciende Display 2
                digito_actual <= 3;      -- Número que queremos mostrar en el Display 2
                estado_sig    <= DSP3;

            when DSP3 =>
                anodos        <= "0111"; -- Enciende Display 3
                digito_actual <= 4;      -- Número que queremos mostrar en el Display 3
                estado_sig    <= DSP0;   -- Reinicia el bucle al Display 0

            when others =>
                anodos        <= "1111"; -- Apaga todos los displays
                digito_actual <= 0;
                estado_sig    <= DSP0;
        end case;
    end process;

    -- 4. DECODIFICADOR BCD A 7 SEGMENTOS (Ánodo Común: '0' enciende, '1' apaga)
    with digito_actual select
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
                     "1111111" when others; -- Apagado total

end architecture rtl;