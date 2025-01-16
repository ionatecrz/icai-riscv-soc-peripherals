library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CircuitoControl is
port(
		clk,reset_n: in std_logic;
		ir_out: in std_logic_vector(31 downto 0);
		m_pc: out std_logic_vector(1 downto 0);
		m_alu_a, m_alu_b: out std_logic_vector(1 downto 0);
		alu_op: out std_logic_vector(3 downto 0);
		wr_pc: out std_logic;
		wr_pc_cond: out std_logic;
		tipo_inst: out std_logic_vector(2 downto 0); 
		m_banco: out std_logic_vector(1 downto 0); 
		m_shamt,en_banco: out std_logic;
		tipo_acc: out std_logic_vector(1 downto 0);
		l_u,en_ir: out std_logic;
		mask_b0,we_ram: out std_logic;
		m_ram,re: out std_logic);
end CircuitoControl;


architecture behavioral of CircuitoControl is
	type t_estados is (Reset,Fetch,Decod,lui3,lwsw3,auipc3,Arit3,Arit4,AritInm,SalCond,lw4,sw4,lw5,jal,jalr);
	signal estado_sig, estado_act: t_estados;
	signal op_code: std_logic_vector(6 downto 2);
	
begin

op_code<=ir_out(6 downto 2);

VarEstados: process(clk, reset_n)
begin
	if reset_n='0' then
		estado_act<=Reset;
	elsif clk'event and clk='1' then
		estado_act<= estado_sig;
	end if;
end process VarEstados;



TransicionEstados: process(estado_act,op_code)
begin
	estado_sig<=estado_act;
case estado_act is

when Reset=> 
	  estado_sig<=Fetch;
	  
when Fetch=>	
	  estado_sig<=Decod;
	  
when Decod=>

	  if op_code= "11011" then --JAL
			 estado_sig <= jal;
	  elsif op_code = "11001" then --JALR
			 estado_sig <= jalr;
	  elsif op_code = "11000" then --SALCOND
			 estado_sig <= SalCond;
	  elsif op_code = "00000" or  op_code = "01000" then --LW or SW
			 estado_sig <= lwsw3;
     elsif op_code = "00101" then --AUIPC
			 estado_sig <= auipc3;
	  elsif op_code = "01101" then --LUI3
			 estado_sig <= lui3;
	  elsif op_code = "01100" then --ARIT3
			 estado_sig <= Arit3;
	  elsif op_code ="00100" then --ARIT INM
			estado_sig<=AritInm;
	  end if;

when AritInm=>
	  estado_sig<=Arit4;
when jal	=>	
	  estado_sig<=Fetch; 	
when jalr =>	
	  estado_sig<=Fetch; 	  	  
when lui3 =>	
	  estado_sig<=Fetch; 		   
when lwsw3	=>	
	  if op_code= "00000" then
	  estado_sig<=lw4;
	  elsif op_code= "01000" then
	  estado_sig<=sw4;
	  end if; 
	  
when lw4	=>	
	  estado_sig<=lw5;
	  
when lw5	=>	
	  estado_sig<=Fetch;
	  
when sw4	=>	
	  estado_sig<=Fetch; 
	  
when auipc3	=>	
	  estado_sig<=Arit4;
	  
when Arit3	=>	
	  estado_sig<=Arit4;
	  
when Arit4	=>	
	  estado_sig<=Fetch; 
	  
when SalCond=>	
	  estado_sig<=Fetch;
 	  
when others => 
     estado_sig<= Reset;
	end case;
end process;

Salidas: process(estado_act)
begin

wr_pc_cond<='0';
m_pc<="00";
wr_pc<='0';
en_ir<='0';
mask_b0<='0';
m_shamt<='0';
en_ir<='0';
en_banco<='0';
l_u<='0';
we_ram<='0';
m_ram<='0';
re<='0';
m_pc<="00";
m_banco<="00";
m_alu_a<="00";
m_alu_b<="00";
tipo_acc<="00";
tipo_inst<=(others => '0');
alu_op<=(others => '0');


	case estado_act is
	when Reset=>
		m_pc<="10";
		wr_pc<='1';
	when Fetch=>
		m_alu_a<="01";
		m_alu_b<="01";
		alu_op <= "0000";
		m_pc<="00";
		wr_pc<='1';
		en_ir<='1';
	when Decod=>
		tipo_inst<="010";
		m_alu_a<="10";
		m_alu_b<="10";
		alu_op <= "0000";
	when AritInm=>
		m_alu_a<="00";
		m_alu_b<="10";
		m_shamt <= '1';
		alu_op <= ir_out(30)&ir_out(14)&ir_out(13)&ir_out(12);

	when jal=>
		m_alu_a<="10";
		m_alu_b<="10";
		alu_op <= "0000";
		tipo_inst<="100";
		m_banco <= "01";
		en_banco <= '1';
		wr_pc <= '1';
		m_pc <= "00";
	when jalr=>
		m_alu_a<="00";
		m_alu_b<="10";
		alu_op <= "0000";
		tipo_inst<="000";
		m_banco <= "01";
		en_banco <= '1';
		wr_pc <= '1';
		mask_b0 <= '1';
		m_pc <= "00";
	when lui3=>
		tipo_inst<="011";
		m_banco <= "01";
		en_banco <= '1';
	when lwsw3=>
		m_alu_a<="00";
		m_alu_b<="10";
		alu_op <= "0000";
		tipo_inst<="000" or "001";
	when auipc3=>
		m_alu_a<="10";
		m_alu_b<="10";
		alu_op <= "0000";
		tipo_inst<="011";
	when Arit3=>
		m_alu_a<="00";
		m_alu_b<="00";
		alu_op <= ir_out(30)&ir_out(14)&ir_out(13)&ir_out(12);
	when SalCond=>
		wr_pc_cond<='1';
		m_alu_a<="00";
		m_alu_b<="00";
		alu_op <= "001"&ir_out(12);
		m_pc <= "01";
	when Arit4=>
		m_ram <= '0';
		m_banco <= "00";
		en_banco <= '1';
	when lw4=>
		tipo_acc <= ir_out(13)&ir_out(12);
		l_u <= ir_out(14);
		re<='1';
	when sw4=>
		tipo_acc <= ir_out(13)&ir_out(12);
		we_ram <= '1';
	when lw5=>
		l_u <= ir_out(14);
		m_banco <= "00";
		en_banco <= '1';
		m_ram <= '1';
	when others =>
		null;
	end case;
end process Salidas;
end behavioral;
