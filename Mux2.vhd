library ieee;
use ieee.std_logic_1164.all;

entity Mux2 is
    port (
        data0 : in std_logic_vector(31 downto 0);
        data1 : in std_logic_vector(31 downto 0);
        data2 : in std_logic_vector(31 downto 0);
        sel   : in std_logic_vector(1 downto 0);
        salida: out std_logic_vector(31 downto 0)  
    ); 
end Mux2;
            
architecture behavioral of Mux2 is
begin
    with sel select
        salida <= data0 when "00",
                  data1 when "01",
                  data2 when "10",
                  "00000000000000000000000000000000" when others;
end behavioral;