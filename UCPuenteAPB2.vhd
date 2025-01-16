library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UCPuenteAPB2 is
port(
    clk, reset_n, acceso: in std_logic;
    PSELX, PENABLE: out std_logic
);
end UCPuenteAPB2;

architecture behavioral of UCPuenteAPB2 is
    type t_estados is (Idle, Setup, Enable);
    signal estado_sig, estado_act: t_estados;
begin

VarEstados: process(clk, reset_n)
begin
    if reset_n = '0' then
        estado_act <= Idle;
    elsif rising_edge(clk) then
        estado_act <= estado_sig;
    end if;
end process VarEstados;

TransicionEstados: process(estado_act, acceso)
begin
    estado_sig <= estado_act;
    case estado_act is
        when Idle =>
            if acceso = '1' then
                estado_sig <= Setup;
            end if;

        when Setup =>
            estado_sig <= Enable;

        when Enable =>
            if acceso = '1' then
                estado_sig <= Setup;
            else
                estado_sig <= Idle;
            end if;

        when others =>
            estado_sig <= Idle;
    end case;
end process TransicionEstados;

Salidas: process(estado_act)
begin
    PSELX <= '0';
    PENABLE <= '0';

    case estado_act is
        when Idle =>
            PSELX <= '0';
            PENABLE <= '0';

        when Setup =>
            PSELX <= '1';
            PENABLE <= '0';

        when Enable =>
            PSELX <= '1';
            PENABLE <= '1';

        when others =>
            null;
    end case;
end process Salidas;

end behavioral;
