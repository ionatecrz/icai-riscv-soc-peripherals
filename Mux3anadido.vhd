library ieee;
use ieee.std_logic_1164.all;

entity Mux3anadido is

port(
        data0 : in std_logic;
        data1 : in std_logic;
        data2 : in std_logic;
        data3 : in std_logic;
        sel   : in std_logic_vector(1 downto 0);
        salida: out std_logic);
end Mux3anadido;
            
architecture behavioral of Mux3anadido is
begin
    with sel select
        salida <= data0 when "00",
                  data1 when "01",
                  data2 when "10",
                  data3 when others;
end behavioral;