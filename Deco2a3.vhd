library ieee;
use ieee.std_logic_1164.all;


entity Deco2a3 is
	port
	(
		tipo_acc : in std_logic_vector(1 downto 0);
		Addr : in std_logic_vector (1 downto 0);
		we_ram: in std_logic;
		we_w,we_b0,we_b1,we_b2,we_b3,we_h0,we_h1: out std_logic);
end Deco2a3;

architecture behavioural of Deco2a3 is
signal s0, s1 : std_logic;
begin

--SEÑALES DE CONTROL
s0 <= '1' when we_ram = '1' and tipo_acc = "00" else '0';
s1 <= '1' when we_ram = '1' and tipo_acc = "01" else '0';

--SALIDAS
we_w<='1' when we_ram='1' and tipo_acc="10" else '0';

we_h0<='1' when s1='1' and Addr(1)='0' else '0';
we_h1<='1' when s1='1' and Addr(1)='1' else '0';

we_b0<='1' when s0='1' and Addr="00" else '0';
we_b1<='1' when s0='1' and Addr="01" else '0';
we_b2<='1' when s0='1' and Addr="10" else '0';
we_b3<='1' when s0='1' and Addr="11" else '0';

end behavioural;