library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_RAM is
end tb_RAM; 

architecture testbench of tb_RAM is

    constant c_clk_semi_period : time := 10 ns;
    constant c_clk_period : time := 2 * c_clk_semi_period;

    signal clk      : std_logic := '0';
    signal Addr     : std_logic_vector(11 downto 0);
    signal Din      : std_logic_vector(31 downto 0);
    signal tipo_acc : std_logic_vector(1 downto 0);
    signal we_ram   : std_logic;
    signal l_u      : std_logic;
    signal Dout     : std_logic_vector(31 downto 0);

    -- intermediate signals
    type mem_4K is array (0 to 4095) of std_logic_vector(7 downto 0);
    signal mem : mem_4K;

    component RAM is
        port(
            clk      : in  std_logic;
            Addr     : in  std_logic_vector(11 downto 0);
            d_in      : in  std_logic_vector(31 downto 0);
            d_out     : out std_logic_vector(31 downto 0);
            tipo_acc : in  std_logic_vector(1 downto 0);
            l_u      : in  std_logic;
            we_ram   : in  std_logic);
    end component RAM;

begin

    clk <= not clk after c_clk_semi_period;

    i1 : RAM
        port map(
            clk      => clk,
            Addr     => Addr,
            d_in      => Din,
            d_out     => Dout,
            tipo_acc => tipo_acc,
            l_u      => l_u,
            we_ram   => we_ram);

    wave : process

    variable semilla1 : integer := 33; -- semilla inicial
    variable semilla2 : integer := 67; -- semilla inicial
    variable r : real;

    variable d_word : std_logic_vector(31 downto 0);
    variable d_half : std_logic_vector(15 downto 0);
    variable d_byte : std_logic_vector(7 downto 0);

    begin

        -- valores iniciales
        tipo_acc <= "10";
        Din      <= (others => '0');
        Addr     <= (others => '0');
        l_u      <= '0';
        we_ram   <= '0';
        wait for 11.5 * c_clk_semi_period;

        -- generación de 1024 palabras aleatorias de 32 bits y escritura en memoria
        for i in 0 to 1023 loop
            uniform(semilla1, semilla2, r);
            r := (2.0**32 - 1.0) * (r - 0.5);
            d_word := std_logic_vector(to_signed(integer(r),32));
            -- almacenamiento en variable de control mem
            mem(4*i + 0) <= d_word(7 downto 0);
            mem(4*i + 1) <= d_word(15 downto 8);
            mem(4*i + 2) <= d_word(23 downto 16);
            mem(4*i + 3) <= d_word(31 downto 24);
            -- escritura en memoria
            Din    <= d_word;
            Addr   <= std_logic_vector(to_unsigned(i, 10)) & "00";
            we_ram <= '1';
            wait for c_clk_period;
            we_ram <= '0';
            wait for c_clk_period;
        end loop;

        Din <= (others => '0');
        we_ram <= '0';

        -- comprobación escritura word / lectura word
        tipo_acc <= "10";
        for i in 0 to 1023 loop
            Addr   <= std_logic_vector(to_unsigned(i, 10)) & "00";
            d_word := mem(4*i + 3) & mem(4*i + 2) & mem(4*i + 1) & mem(4*i + 0);
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura word / lectura word"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- comprobación escritura word / lectura half
        tipo_acc <= "01";
        for i in 0 to 2047 loop
            Addr   <= std_logic_vector(to_unsigned(i, 11)) & '0';
            d_half := mem(2*i + 1) & mem(2*i + 0);
            d_word(31 downto 16) := (others => '0');
            d_word(15 downto 0)  := d_half;
            -- comprobación sin signo
            l_u <= '1';
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura word / lectura half sin signo"
                severity failure;
            -- comprobación con signo
            l_u <= '0';
            d_word(31 downto 16) := (others => d_half(15));
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura word / lectura half con signo"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- comprobación escritura word / lectura byte
        tipo_acc <= "00";
        for i in 0 to 4095 loop
            Addr   <= std_logic_vector(to_unsigned(i, 12));
            d_byte := mem(i);
            d_word(31 downto 8) := (others => '0');
            d_word(7 downto 0)  := d_byte;
            -- comprobación sin signo
            l_u <= '1';
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura word / lectura byte sin signo"
                severity failure;
            -- comprobación con signo
            l_u <= '0';
            d_word(31 downto 8) := (others => d_byte(7));
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura word / lectura byte con signo"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- ________________________________________________________________________
        -- generación de 2048 palabras aleatorias de 16 bits y escritura en memoria
        tipo_acc <= "01";
        for i in 0 to 2047 loop
            uniform(semilla1, semilla2, r);
            r := (2.0**16 - 1.0) * (r - 0.5);
            d_half := std_logic_vector(to_signed(integer(r),16));
            -- almacenamiento en variable de control mem
            mem(2*i + 0) <= d_half(7 downto 0);
            mem(2*i + 1) <= d_half(15 downto 8);
            -- escritura en memoria
            Din    <= "0000000000000000" & d_half;
            Addr   <= std_logic_vector(to_unsigned(i, 11)) & '0';
            we_ram <= '1';
            wait for c_clk_period;
            we_ram <= '0';
            wait for c_clk_period;
        end loop;

        Din <= (others => '0');
        we_ram <= '0';

        -- comprobación escritura half / lectura word
        tipo_acc <= "10";
        for i in 0 to 1023 loop
            Addr   <= std_logic_vector(to_unsigned(i, 10)) & "00";
            d_word := mem(4*i + 3) & mem(4*i + 2) & mem(4*i + 1) & mem(4*i + 0);
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura half / lectura word"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- comprobación escritura half / lectura half
        tipo_acc <= "01";
        for i in 0 to 2047 loop
            Addr   <= std_logic_vector(to_unsigned(i, 11)) & '0';
            d_half := mem(2*i + 1) & mem(2*i + 0);
            d_word(31 downto 16) := (others => '0');
            d_word(15 downto 0)  := d_half;
            -- comprobación sin signo
            l_u <= '1';
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura half / lectura half sin signo"
                severity failure;
            -- comprobación con signo
            l_u <= '0';
            d_word(31 downto 16) := (others => d_half(15));
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura half / lectura half con signo"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- comprobación escritura half / lectura byte
        tipo_acc <= "00";
        for i in 0 to 4095 loop
            Addr   <= std_logic_vector(to_unsigned(i, 12));
            d_byte := mem(i);
            d_word(31 downto 8) := (others => '0');
            d_word(7 downto 0)  := d_byte;
            -- comprobación sin signo
            l_u <= '1';
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura half / lectura byte sin signo"
                severity failure;
            -- comprobación con signo
            l_u <= '0';
            d_word(31 downto 8) := (others => d_byte(7));
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura half / lectura byte con signo"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- _______________________________________________________________________
        -- generación de 4096 palabras aleatorias de 8 bits y escritura en memoria
        tipo_acc <= "00";
        for i in 0 to 4095 loop
            uniform(semilla1, semilla2, r);
            r := (2.0**8 - 1.0) * (r - 0.5);
            d_byte := std_logic_vector(to_signed(integer(r),8));
            -- almacenamiento en variable de control mem
            mem(i) <= d_byte;
            -- escritura en memoria
            Din    <= "000000000000000000000000" & d_byte;
            Addr   <= std_logic_vector(to_unsigned(i, 12));
            we_ram <= '1';
            wait for c_clk_period;
            we_ram <= '0';
            wait for c_clk_period;
        end loop;

        Din <= (others => '0');
        we_ram <= '0';

        -- comprobación escritura byte / lectura word
        tipo_acc <= "10";
        for i in 0 to 1023 loop
            Addr   <= std_logic_vector(to_unsigned(i, 10)) & "00";
            d_word := mem(4*i + 3) & mem(4*i + 2) & mem(4*i + 1) & mem(4*i + 0);
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura byte / lectura word"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- comprobación escritura byte / lectura half
        tipo_acc <= "01";
        for i in 0 to 2047 loop
            Addr   <= std_logic_vector(to_unsigned(i, 11)) & '0';
            d_half := mem(2*i + 1) & mem(2*i + 0);
            d_word(31 downto 16) := (others => '0');
            d_word(15 downto 0)  := d_half;
            -- comprobación sin signo
            l_u <= '1';
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura byte / lectura half sin signo"
                severity failure;
            -- comprobación con signo
            l_u <= '0';
            d_word(31 downto 16) := (others => d_half(15));
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura byte / lectura half con signo"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- comprobación escritura byte / lectura byte
        tipo_acc <= "00";
        for i in 0 to 4095 loop
            Addr   <= std_logic_vector(to_unsigned(i, 12));
            d_byte := mem(i);
            d_word(31 downto 8) := (others => '0');
            d_word(7 downto 0)  := d_byte;
            -- comprobación sin signo
            l_u <= '1';
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura byte / lectura byte sin signo"
                severity failure;
            -- comprobación con signo
            l_u <= '0';
            d_word(31 downto 8) := (others => d_byte(7));
            wait for c_clk_period;
            assert Dout = d_word
                report "Fallo en escritura byte / lectura byte con signo"
                severity failure;
            wait for c_clk_period;
        end loop;

        -- fin de la simulación
        assert false
            report "Fin de la simulacion"
            severity failure;
    end process; 

end architecture;