library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_IR is
port(
		pc_in: in std_logic_vector(31 downto 0);
		clk: in std_logic;
		reset_n: in std_logic;
		En: in std_logic;
		pc_ir: out std_logic_vector(31 downto 0));
end PC_IR;

architecture behavioral of PC_IR is

begin 

process(clk, reset_n)
	begin 
		if reset_n='0' then
			pc_ir <= (others=>'0');
		elsif clk'event and clk='1' then
			if En='1' then 
				pc_ir <= pc_in;
			end if;
		end if;
end process;
	
end behavioral;