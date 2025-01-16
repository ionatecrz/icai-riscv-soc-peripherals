library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR is
port(
		ir_in: in std_logic_vector(31 downto 0);
		clk: in std_logic;
		reset_n: in std_logic;
		En: in std_logic;
		ir_out: out std_logic_vector(31 downto 0));
end IR;

architecture behavioral of IR is

begin 

process(clk, reset_n)
	begin 
		if reset_n='0' then
			ir_out <= (others=>'0');
		elsif clk'event and clk='1' then
			if En='1' then 
				ir_out <= ir_in;
			end if;
		end if;
end process;
	
end behavioral;