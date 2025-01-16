library ieee;
use ieee.std_logic_1164.all;

entity Mux1 is
	port (
			data0 : in std_logic_vector(31 downto 0);
			data1 : in std_logic_vector(31 downto 0);
			sel   : in std_logic;
			salida: out std_logic_vector(31 downto 0)); 
end Mux1;
			
architecture behavioral of Mux1 is
begin

with sel select
salida<=data0 when '0',
		  data1 when '1',
		  "00000000000000000000000000000000" when others;
end behavioral;