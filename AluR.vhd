library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AluR is
port(
		alur_in: in std_logic_vector(31 downto 0);
		clk: in std_logic;
		reset_n: in std_logic;
		En: in std_logic;
		alur_out: out std_logic_vector(31 downto 0));
end AluR;

architecture behavioral of AluR is

begin 

process(clk, reset_n)
	begin 
		if reset_n='0' then
			alur_out <= (others=>'0');
		elsif clk'event and clk='1' then
			if En='1' then 
				alur_out <= alur_in;
			end if;
		end if;
end process;
	
end behavioral;