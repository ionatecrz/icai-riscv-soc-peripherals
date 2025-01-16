library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
entity ALU32 is
    generic (
        g_n_bits1 : integer := 32;
        g_n_bits2 : integer := 5);
    port (
        a, b : in std_logic_vector(g_n_bits1-1 downto 0);
        shamt : in std_logic_vector(g_n_bits2-1 downto 0);
        alu_op : in std_logic_vector(3 downto 0);
        z, lt, ge : out std_logic;
        alu_out : out std_logic_vector(g_n_bits1-1 downto 0));
end ALU32;

architecture behavioral of ALU32 is
    signal signo : std_logic;
    signal a_i, b_i : std_logic_vector(g_n_bits1 downto 0);
    signal alu_out_i : std_logic_vector(g_n_bits1 downto 0);
    constant c_0 : std_logic_vector(g_n_bits1-2 downto 0) := (others => '0');

begin
    z <= '1' when unsigned(a) = unsigned(b) else '0';
    lt <= signo;
    ge <= not(signo);

    alu : process (a, b, alu_op, shamt, a_i, b_i, alu_out_i, signo)
    begin

        case alu_op is

            when "0000" =>
					 a_i <= '0' & a;
					 b_i <= '0' & b;
                alu_out_i <= std_logic_vector(signed(a_i) + signed(b_i)); --Sumador en alto nivel
                signo <= alu_out_i(g_n_bits1);
                alu_out <= alu_out_i(g_n_bits1-1 downto 0);
					 
				when "0001" =>
				   a_i <= '0' & a;
					b_i <= '0' & b;
					alu_out <= std_logic_vector(shift_left(unsigned(a),to_integer(unsigned(shamt))));
					
				when "0010" => 
					 a_i <= a(g_n_bits1-1) & a;
					 b_i <= b(g_n_bits1-1) & b;
                alu_out_i <= std_logic_vector(signed(a_i) - signed(b_i)); --Restador en alto nivel
                signo <= alu_out_i(g_n_bits1);
                alu_out <= alu_out_i(g_n_bits1-1 downto 0);
                alu_out <= c_0 & signo;
					 
				when "0011" =>
					 a_i <= '0' & a;
					 b_i <= '0' & b;
                alu_out_i <= std_logic_vector(unsigned(a_i) - unsigned(b_i));
                signo <= alu_out_i(g_n_bits1);
                alu_out <= alu_out_i(g_n_bits1-1 downto 0);
                alu_out <= c_0 & signo;
					 
				when "0100" =>
					a_i <= '0' & a;
					b_i <= '0' & b;
					alu_out <= a xor b;
					
				when "0101" =>
					a_i <= '0' & a;
					b_i <= '0' & b;
					alu_out <= std_logic_vector(shift_right(unsigned(a),to_integer(unsigned(shamt))));
					
				when "0110" =>
					a_i <= '0' & a;
					b_i <= '0' & b;
					alu_out <= a or b;
					
				when "0111" =>
					a_i <= '0' & a;
					b_i <= '0' & b;
					alu_out <= a and b;
					
					 
            when "1000" =>
					 a_i <= '0' & a;
					 b_i <= '0' & b;
                alu_out_i <= std_logic_vector(signed(a_i) - signed(b_i));
                signo <= alu_out_i(g_n_bits1);
                alu_out <= alu_out_i(g_n_bits1-1 downto 0);
					 
				
				when "1101" => 
					a_i <= '0' & a;
					b_i <= '0' & b;
					alu_out <= std_logic_vector(shift_right(signed(a),to_integer(unsigned(shamt))));
				
				when others=>
						null;
				
				
		end case;
	end process;
end behavioral;
