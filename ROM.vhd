library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
 port(
	 clk: in std_logic; -- Synchronous ROM
	 en_pc: in std_logic; -- With enable
	 addr: in std_logic_vector(31 downto 0); -- Address bus
	 data: out std_logic_vector(31 downto 0) ); -- Data out
end ROM;
architecture Behavioural of ROM is
 -- The internal address is word address, no byte address
 signal internal_addr : std_logic_vector(29 downto 0);
 -- ROM declaration
type mem_t is array (0 to 10 ) of std_logic_vector(31 downto 0);

 signal memory : mem_t:= (
		 0 => X"f0f104b7", -- li s1, 0xF0F0FFFF
		 1 => X"fff48493", --
		 2 => X"0f0f0937", -- li s2, 0x0F0F00FF
		 3 => X"0ff90913", --
		 4 => X"012489b3", -- add s3, s1, s2
		 5 => X"40990a33", -- sub s4, s2, s1
		 6 => X"0124eab3", -- or s5, s1, s2
		 7 => X"0124fb33", -- and s6, s1, s2
		 8 => X"0124cbb3", -- xor s7, s1, s2
		 others => X"00000000");
		 
begin
 internal_addr <= addr(31 downto 2);
 
	 mem_rom: process(clk)
		 begin
			 if clk'event and clk = '1' then
				 if en_pc = '1' then
					data <= memory(to_integer(unsigned(internal_addr)));
				 end if;
			 end if;
	 end process mem_rom;
end architecture Behavioural;