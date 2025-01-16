library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity periferico is
    port (
        PWDATA : in std_logic_vector(31 downto 0);
        PADDR : in std_logic_vector(3 downto 2);
        PWRITE, PSELX, PENABLE : in std_logic;
        clk : in std_logic;
        PRDATA : out std_logic_vector(31 downto 0)
    );
end periferico;

architecture behavioral of periferico is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if PENABLE = '1' and PSELX = '1' then
                if PADDR = "00" then
                    if PWRITE = '1' then
                        PRDATA <= PWDATA;
                    end if;
                elsif PADDR = "01" then
                    if PWRITE = '1' then
                        PRDATA <= PWDATA and "00000000111111111111111111111111";
                    end if;
                elsif PADDR = "10" then
                    if PWRITE = '1' then
                        PRDATA <= PWDATA and "00000000000000000000000011111111";
                    end if;
                elsif PADDR = "11" then
                    if PWRITE = '1' then
                        PRDATA <= PWDATA and "00000000000000001111111100000000";
                    end if;
                end if;
            end if;
        end if;
    end process;
end behavioral;
