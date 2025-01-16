library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISCV is
	generic(  
		n:integer:=32);
	port(
		l_u,we_ram,re: out std_logic;
		dato_val: in std_logic;
		Addr: out std_logic_vector(31 downto 0);
		tipo_acc:out std_logic_vector(1 downto 0);
		d_in: in std_logic_vector(n-1 downto 0);
		d_out: out std_logic_vector(n-1 downto 0);
		clk, reset_n: in std_logic);
end RISCV;

architecture structural of RISCV is  
 signal en_ir: std_logic;
 signal ir_out :std_logic_vector(n-1 downto 0);
 signal en_banco: std_logic;
 signal alu_op: std_logic_vector(3 downto 0);
 signal tipo_inst: std_logic_vector(2 downto 0);
 signal m_pc: std_logic_vector(1 downto 0);
 signal m_alu_a: std_logic_vector(1 downto 0);
 signal m_alu_b: std_logic_vector(1 downto 0);
 signal wr_pc: std_logic;
 signal m_ram: std_logic;
 signal m_banco: std_logic_vector(1 downto 0);
 signal wr_pc_cond: std_logic;
 
 begin
 
 UnidadControl: entity work.CircuitoControl   
port map(
clk=>clk,
reset_n=>reset_n,
ir_out=>ir_out,
m_pc=>m_pc,
wr_pc=>wr_pc,
m_alu_a=>m_alu_a,
m_alu_b=>m_alu_b,
alu_op=>alu_op,
wr_pc_cond=>wr_pc_cond,
tipo_inst=>tipo_inst,
m_banco=>m_banco,
en_banco=>en_banco,
tipo_acc=>tipo_acc,
l_u=>l_u,
we_ram=>we_ram,
en_ir=>en_ir,
m_ram=>m_ram);

RUTA: entity work.ruta_datos
generic map(  
n=> n)
port map(
Addr=>Addr,
clk=>clk,
d_in=>d_in,
d_out=>d_out,
reset_n=>reset_n);

end structural;