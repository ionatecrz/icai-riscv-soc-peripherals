library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decod is
    port (
        sel : in std_logic_vector(1 downto 0);
        PSEL3 : out std_logic;
        PSEL2 : out std_logic;
        PSEL1 : out std_logic;
        PSEL0 : out std_logic;
		  en: in std_logic
    );
end decod;

architecture behavioral of decod is
begin

	PSEL0<='1' when sel="00" and en='1' else '0';
	PSEL1<='1' when sel="01" and en='1' else '0';
	PSEL2<='1' when sel="10" and en='1' else '0';
	PSEL3<='1' when sel="11" and en='1' else '0';
    
end behavioral;
