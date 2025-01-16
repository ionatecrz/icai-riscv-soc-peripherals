library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PuenteAPB2 is
	port(                    
			 addr     : in  std_logic_vector(31 downto 0); 
			 d_in     : in  std_logic_vector(31 downto 0);  
			 we,re    : in  std_logic; 
			 PRDATA0,PRDATA1,PRDATA2,PRDATA3: in std_logic_vector(7 downto 0);
			 PADDR    : out  std_logic_vector(3 downto 0); 
			 PSEL0,PSEL1,PSEL2,PSEL3: out  std_logic;
			 PWRITE,PENABLE: out  std_logic;
			 PWDATA   : out std_logic_vector(31 downto 0);
			 dato_val : out  std_logic;
			 d_out    : out std_logic_vector(31 downto 0);
			 clk, reset_n: in std_logic);
end PuenteAPB2;

architecture structural of PuenteAPB2 is 

signal zeros: std_logic_vector(23 downto 0):=(others=>'0');
signal acceso,PSELX,penablex: std_logic;

begin

acceso<=addr(31) and (re or we);

process(clk, reset_n)
    begin
        if reset_n = '0' then
            PADDR <= (others =>'0');
        elsif clk'event and clk='1' then
            if acceso = '1' then
                PADDR <= addr(3 downto 0);
            end if;
        end if;
    end process;

process (clk, reset_n)
    begin
        if reset_n = '0' then
            PWRITE <= '0';
        elsif clk'event and clk='1' then
            if acceso = '1' then
                PWRITE <= we;
            end if;
        end if;
    end process;

process (clk, reset_n)
    begin
        if reset_n = '0' then
            PWDATA <= (others =>'0');
        elsif clk'event and clk='1' then
            if acceso = '1' then
                PWDATA <= d_in;
            end if;
        end if;
    end process;

Decod: entity work.decod   
port map(
		sel=>addr(5 downto 4),
		en=>PSELX,
		PSEL0=>PSEL0,
		PSEL1=>PSEL1,
		PSEL2=>PSEL2,
		PSEL3=>PSEL3);

UnidadCtrl: entity work.UCPuenteAPB2   
port map(
		clk=>clk,
		reset_n=>reset_n,
		acceso=>acceso,
		PSELX=>PSELX,
		PENABLE=>penablex);


Mux3: entity work.Mux3   
port map(
	data0=>zeros & PRDATA0,
	data1=>zeros & PRDATA1,
	data2=>zeros & PRDATA2,
	data3=>zeros & PRDATA3,
	sel=>addr(5 downto 4),
	salida=>d_out);

PENABLE<=penablex;
dato_val<=penablex;

end structural;