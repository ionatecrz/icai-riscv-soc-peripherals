library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all; -- for log2 and ceil

entity RAM is
  
  generic (
    g_ram_words : integer := 128);      -- Number of words of the RAM

  port (
    clk      : in  std_logic;                      -- Synchronous RAM
    addr     : in  std_logic_vector(31 downto 0);  -- address bus
    d_in     : in  std_logic_vector(31 downto 0);  -- data in bus
    acc_type : in  std_logic_vector(1  downto 0);  -- 00 byte, 01 half, 10 word
    we       : in  std_logic;                      -- write enable
    l_u      : in  std_logic;                      -- 1 load unsigned
    d_out    : out std_logic_vector(31 downto 0));

end entity RAM;
architecture behavioural of RAM is
  -- RAM declaration
  type ram_t is array (0 to g_ram_words-1) of std_logic_vector(7 downto 0);
  signal ram_0, ram_1, ram_2, ram_3 : ram_t;
  signal d_in_0, d_in_1, d_in_2, d_in_3 : std_logic_vector(7 downto 0);
  signal d_out_0, d_out_1, d_out_2, d_out_3 : std_logic_vector(7 downto 0);

  -- internal address bus for the ram blocks (word address). The width of the
  -- bus is given by the number of words.
  constant c_addr_width : integer := integer(ceil(log2(real(g_ram_words))));
  signal addr_ram_block : std_logic_vector(c_addr_width-1 downto 0);
  
  signal we_b : std_logic_vector(3 downto 0); -- write en. for byte acc.
  signal we_h : std_logic_vector(1 downto 0); -- write en. for half acc.

  signal we_byte, we_half, we_word : std_logic; -- we decoded

  -- signals for the reading circuit
  signal byte_out: std_logic_vector(7 downto 0);
  signal half_out: std_logic_vector(15 downto 0);
  signal byte_out_sign, half_out_sign : std_logic_vector(31 downto 0);
  -- signals for the sign extension in the reading circuit
  signal byte_sign_ext : std_logic_vector(31 downto 8);
  signal half_sign_ext : std_logic_vector(31 downto 16);
  
begin  -- architecture behavioural

  -- The internal addr bus is mapped to the word address of the input bus (the
  -- 2 LSB are no part of this word address. Because the bus width is
  -- c_addr_width, the assigment goes from bit 2 to (c_addr_width-1)+2
  addr_ram_block <= addr(c_addr_width-1+2 downto 2);

  -- The we signal is decoded based on the acc_type signal
  we_byte <= we when acc_type = "00" else
             '0';
  we_half <= we when acc_type = "01" else
             '0';
  we_word <= we when acc_type = "10" else
             '0';
  
  -- write enable decoders
  with addr(1 downto 0) select
    we_b <=
    "000" & we_byte when "00",
    "00" & we_byte & '0' when "01",
    '0' & we_byte & "00" when "10",
    we_byte & "000" when "11",
    "XXXX" when others;
  
  with addr(1 downto 0) select
    we_h <=
    '0' & we_half when "00",
    we_half & '0' when "10",
    "XX" when others; -- If the access is unaligned, an error will be
                      -- generated in simulation. In a real implementation,
                      -- an exception will be generated, so this signal is
                      -- not relevant.
  
  -- Block 0 implementation (bits 7 downto 0)
  -- input multiplexer (in this case is reduntant, the compiler will get rid of
  -- it)
  d_in_0 <= d_in(7 downto 0) when acc_type = "00" else
            d_in(7 downto 0) when acc_type = "01" else
            d_in(7 downto 0);
  mem_ram_0: process(clk)
  begin
    if clk'event and clk = '1' then
      if we_b(0) = '1' or we_h(0) = '1' or we_word = '1' then
        ram_0(to_integer(unsigned(addr_ram_block))) <= d_in_0;
      end if;
      d_out_0 <= ram_0(to_integer(unsigned(addr_ram_block)));
    end if;
  end process;

  -- Block 1 implementation (bits 15 downto 8)
  -- input multiplexer
  d_in_1 <= d_in(7  downto 0) when acc_type = "00" else
            d_in(15 downto 8) when acc_type = "01" else
            d_in(15 downto 8);
  mem_ram_1: process(clk)
  begin
    if clk'event and clk = '1' then
      if we_b(1) = '1' or we_h(0) = '1' or we_word = '1' then
        ram_1(to_integer(unsigned(addr_ram_block))) <= d_in_1;
      end if;
      d_out_1 <= ram_1(to_integer(unsigned(addr_ram_block)));
    end if;
  end process;

  -- Block 2 implementation (bits 23 downto 16)
  -- input multiplexer
  d_in_2 <= d_in(7  downto  0) when acc_type = "00" else
            d_in(7  downto  0) when acc_type = "01" else
            d_in(23 downto 16);
  mem_ram_2: process(clk)
  begin
    if clk'event and clk = '1' then
      if we_b(2) = '1' or we_h(1) = '1' or we_word = '1' then
        ram_2(to_integer(unsigned(addr_ram_block))) <= d_in_2;
      end if;
      d_out_2 <= ram_2(to_integer(unsigned(addr_ram_block)));
    end if;
  end process;

  -- Block 3 implementation (bits 31 downto 24)
  -- input multiplexer
  d_in_3 <= d_in(7  downto  0) when acc_type = "00" else
            d_in(15 downto  8) when acc_type = "01" else
            d_in(31 downto 24);
  mem_ram_3: process(clk)
  begin
    if clk'event and clk = '1' then
      if we_b(3) = '1' or we_h(1) = '1' or we_word = '1' then
        ram_3(to_integer(unsigned(addr_ram_block))) <= d_in_3;
      end if;
      d_out_3 <= ram_3(to_integer(unsigned(addr_ram_block)));
    end if;
  end process;

  -- reading circuit.
  -- byte access mux
   with addr(1 downto 0) select
    byte_out <=
    d_out_0 when "00",
    d_out_1 when "01",
    d_out_2 when "10",
    d_out_3 when "11",
     (others => 'X') when others;

  -- half access mux
  with addr(1 downto 0) select
    half_out <=
    d_out_1 & d_out_0 when "00",
    d_out_3 & d_out_2 when "10",
    (others => 'X') when others; -- If the access is unaligned, an error will be
                        -- generated in simulation. In a real implementation,
                        -- an exception will be generated, so this signal is
                        -- not relevant.
  -- sign extension
  byte_sign_ext <= (others => byte_out(7)) when l_u = '0' else
                   (others => '0');
  half_sign_ext <= (others => half_out(15)) when l_u = '0' else
                   (others => '0');

  -- output mux
  with acc_type select
    d_out <=
    byte_sign_ext & byte_out when "00",
    half_sign_ext & half_out when "01",
    d_out_3 & d_out_2 & d_out_1 & d_out_0 when "10",
    (others => 'X') when others;
  
end architecture behavioural;
