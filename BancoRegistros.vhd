library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BancoRegistros is
    port (
        din: in std_logic_vector(31 downto 0);
        AddrA, AddrB, AddrW: in std_logic_vector(4 downto 0);
        EnW, clk, reset_n: in std_logic;
        RegA, RegB: out std_logic_vector(31 downto 0)
    );
end BancoRegistros;

architecture behavioural of BancoRegistros is
    type banco_block is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal s: banco_block;
begin

    
    banco: process(clk, reset_n)
    begin
        if reset_n = '0' then
            s <= (others => (others => '0'));
        elsif rising_edge(clk) then
		  
		  s(0)<= (others => '0');

            if EnW = '1' then
                if AddrW /= "00000" then
                    s(to_integer(unsigned(AddrW))) <= din;
                end if;
            end if;
        end if;
    end process banco;
	 RegA <= s(to_integer(unsigned(AddrA)));
    RegB <= s(to_integer(unsigned(AddrB)));
end behavioural;
