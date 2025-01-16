library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity ruta_datos is
	generic(  
			n:integer:=32);
	port( 
		d_in: in std_logic_vector(n-1 downto 0);
		Addr: out std_logic_vector(31 downto 0);
		d_out: out std_logic_vector(n-1 downto 0);
		clk, reset_n: in std_logic);
		
end ruta_datos;

architecture structural of ruta_datos is  
signal pc_in: std_logic_vector(n-1 downto 0);
signal en_pc:  std_logic;
signal pc_out: std_logic_vector(n-1 downto 0);
signal ir_in:std_logic_vector(n-1 downto 0);
signal en_ir: std_logic;
signal ir_out :std_logic_vector(n-1 downto 0);
signal pc_ir :std_logic_vector(n-1 downto 0);
signal alu_out: std_logic_vector(n-1 downto 0);
signal alur_out: std_logic_vector(n-1 downto 0);
signal en_banco: std_logic;
signal Din: std_logic_vector(n-1 downto 0);
signal reg_a: std_logic_vector(n-1 downto 0);
signal reg_b: std_logic_vector(n-1 downto 0);
signal a: std_logic_vector(n-1 downto 0);
signal b: std_logic_vector(n-1 downto 0);
signal shamt: std_logic_vector(4 downto 0);
signal alu_op: std_logic_vector(3 downto 0);
signal z: std_logic;
signal lt: std_logic;
signal ge: std_logic;
signal tipo_inst: std_logic_vector(2 downto 0);
signal mask_b0: std_logic;
signal inm: std_logic_vector(n-1 downto 0);
signal m_pc: std_logic_vector(1 downto 0);
signal d_ram_alu: std_logic_vector(n-1 downto 0);
signal m_alu_a: std_logic_vector(1 downto 0);
signal m_alu_b: std_logic_vector(1 downto 0);
signal Dout:  std_logic_vector(n-1 downto 0);
signal m_shamt: std_logic;
signal wr_pc: std_logic;
signal m_ram: std_logic;
signal m_banco,tipo_acc: std_logic_vector(1 downto 0);
signal wr_pc_cond,l_u,we_ram: std_logic;
signal salida_and: std_logic;
signal salida_mux1: std_logic;
signal alur_in : std_logic_vector(31 downto 0);

begin
en_pc <= wr_pc or salida_and;
salida_and <= wr_pc_cond and salida_mux1;

PC: entity work.PC
port map (
	pc_in => pc_in,
	reset_n => reset_n,
	clk => clk,
	En => en_pc,
	pc_out => pc_out);

IR: entity work.IR

port map (
	ir_in => ir_in,
	reset_n => reset_n,
	clk => clk,
	En => en_ir,
	ir_out => ir_out);

PC_IR_REG: entity work.PC_IR

port map (
	pc_in => pc_in,
	reset_n => reset_n,
	clk => clk,
	en => en_ir,
	pc_ir => pc_ir);

ALU_R: entity work.AluR

port map (
	alur_in => alur_in,
	reset_n => reset_n,
	clk => clk,
	en => '1',
	alur_out => alur_out);

BancoReg: entity work.BancoRegistros

port map(

		clk => clk,
		reset_n => reset_n,
		EnW=> en_banco,
		AddrA => ir_out (19 downto 15),
		AddrB => ir_out (24 downto 20),
		AddrW => ir_out (11 downto 7),
		Din => Din,
		RegA => reg_a,
		RegB => reg_b);


ALU: entity work.ALU32

port map(
		a => a,
		b => b,
		shamt => shamt,
		alu_op => alu_op,
		z => z,
		lt => lt,
		ge => ge,
		alu_out => alu_out);

GeneradorInmediatos: entity work.GeneradorInmediatos

port map (

		inst => ir_out,
		tipo_inst => tipo_inst,
		mask_b0 => mask_b0,
		inm => inm);

Mux3anadido: entity work.Mux3anadido

port map(

		data0 => z,
		data1 => not z,
		data2 => lt,
		data3 => ge,		
		sel => ir_out(14)&ir_out(12),
		salida=> salida_mux1);

Mux2: entity work.Mux2

port map(
		data0 => alu_out,
		data1 => alur_out,
		data2 => std_logic_vector(to_unsigned(0,32)),		
		sel =>m_pc,
		salida => pc_in);


Mux3: entity work.Mux2

port map(
		data0 => d_ram_alu,
		data1 => pc_out,
		data2 => inm,		
		sel =>m_banco,
		salida => Din);
		

Mux4: entity work.Mux2

port map(
		data0 => reg_a,
		data1 => pc_out,
		data2 => pc_ir,		
		sel =>m_alu_a,
		salida => a);

Mux5: entity work.Mux2

port map(
		data0 => reg_b,
		data1 => std_logic_vector(to_unsigned(4,32)),
		data2 => inm,		
		sel =>m_alu_b,
		salida => b);

Mux6: entity work.Mux1

port map(
		data0 =>alur_out,
		data1 => Dout,	
		sel => m_ram,	
		salida => d_ram_alu);
		


ROM: entity work.ROM

port map(

		clk => clk, 
		en_pc => en_pc,
		addr => pc_out,
		data => ir_in);		
		

end structural;