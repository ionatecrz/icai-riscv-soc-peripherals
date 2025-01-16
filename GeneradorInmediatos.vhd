library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GeneradorInmediatos is
port(
		inst: in std_logic_vector(31 downto 0);
		tipo_inst: in std_logic_vector(2 downto 0);
		mask_b0: in std_logic;
		inm: out std_logic_vector(31 downto 0));
end GeneradorInmediatos;

architecture behavioral of GeneradorInmediatos is

signal TYPE_I : std_logic_vector(2 downto 0) := "000";
signal TYPE_S : std_logic_vector(2 downto 0) := "001";
signal TYPE_B : std_logic_vector(2 downto 0) := "010";
signal TYPE_U : std_logic_vector(2 downto 0) := "011";
signal TYPE_J : std_logic_vector(2 downto 0) := "100";

signal signo: std_logic_vector(19 downto 0);
signal zero: std_logic_vector(11 downto 0);
signal inm_sinmask:std_logic_vector(31 downto 0);

begin

signo<=(others=>inst(31));
zero<=(others=>'0');

with tipo_inst select
inm_sinmask<=signo & inst(31 downto 20) when TYPE_I,
				 signo & inst(31 downto 25) & inst(11 downto 7) when TYPE_S,
				 signo(19 downto 3) & inst(31)& inst(7)& inst(30 downto 25)& inst(11 downto 6)&  '0'  when TYPE_B,
				 inst(31 downto 12) & zero when TYPE_U,
				 signo & inst(31 downto 20) when TYPE_J,
				 null when others;
	 
inm<=inm_sinmask(31 downto 1)& mask_b0;
end behavioral;