library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pract5 is
	port(
		clk, reset_n: in std_logic);
end Pract5;

architecture structural of Pract5 is 

signal dato_val_p,dato_val,l_u,we_ram,re: std_logic;
signal Addr,d_in,d_out_p,d_out_ram: std_logic_vector(31 downto 0);
signal tipo_acc: std_logic_vector(1 downto 0);
signal PSEL0,PSEL1,PSEL2,PSEL3,PWRITE,PENABLE: std_logic;
signal PWDATA,prdata_0,prdata_1: std_logic_vector(31 downto 0);
signal PRDATA0,PRDATA1,PRDATA2,PRDATA3: std_logic_vector(7 downto 0);
signal PADDR: std_logic_vector(3 downto 0);
signal zeros: std_logic_vector(23 downto 0):=(others=>'0');

begin

RISCV: entity work.RISCV   
port map(
		l_u=>l_u,
		we_ram=>we_ram,
		re=>re,
		dato_val=>dato_val,
		Addr=>Addr,
		tipo_acc=>tipo_acc,
		d_in=>d_in,
		d_out=>d_out_ram,
		clk=>clk,
		reset_n=>reset_n);
		
		
PuenteAPB2: entity work.PuenteAPB2
port map(              
			 addr=>Addr,
			 d_in=>d_in,
			 we=>we_ram,
			 re=>re,
			 PRDATA0=>PRDATA0,
			 PRDATA1=>PRDATA1,
			 PRDATA2=>PRDATA2,
			 PRDATA3=>PRDATA3,
			 PADDR=>PADDR,
			 PSEL0=>PSEL0,
			 PSEL1=>PSEL1,
			 PSEL2=>PSEL2,
			 PSEL3=>PSEL3,
			 PWRITE=>PWRITE,
			 PENABLE=>PENABLE,
			 PWDATA=>PWDATA,
			 dato_val=>dato_val_p,
			 d_out=>d_out_p,
			 clk=>clk, 
			 reset_n=>reset_n);


d_in<=d_out_ram when Addr(31)='0' else d_out_p; --multiplexor1
dato_val<=dato_val_p when Addr(31)='1' else '1'; --multiplexor2
		
RAM: entity work.RAM   
port map(
		acc_type=>tipo_acc,
		addr=>Addr,
		clk=>clk,
		l_u=>l_u,
		we=>we_ram and not Addr(31),
		d_in=>d_in,
		d_out=>d_out_ram);
		
PEP: entity work.periferico 
port map(
		PWDATA=>PWDATA,
      PADDR=>PADDR(1 downto 0),
      PWRITE=>PWRITE,
		PSELX=>PSEL0, 
		PENABLE=>PENABLE,
      clk=>clk,
      PRDATA=>prdata_0);
		
PSP: entity work.periferico 
port map(
		PWDATA=>PWDATA,
      PADDR=>PADDR(1 downto 0),
      PWRITE=>PWRITE,
		PSELX=>PSEL1, 
		PENABLE=>PENABLE,
      clk=>clk,
      PRDATA=>prdata_1);
		
PRDATA0<=prdata_0(7 downto 0);
PRDATA1<=prdata_1(7 downto 0);


end structural;