----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2017 08:22:16 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal shifter : std_logic_vector (1 downto 0);
    signal counter : std_logic_vector (21 downto 0) := (others => '0');
    constant count_max : std_logic_vector (21 downto 0) := "1001100010010110100000";
begin

    dbnc_process : process(clk)
    begin
            
        if rising_edge(clk) then
            
            shifter(1) <= shifter(0);
            shifter(0) <= btn;
            
            if ( shifter(1) /= '1' ) then
                counter <= (others => '0');
                dbnc <= '0';
            
            elsif ( shifter(1) = '1' ) then
                if (counter < count_max) then
                    counter <= std_logic_vector( unsigned(counter) + 1);
                else
                    dbnc <= shifter(1);
                end if;
            end if;
        end if;
    end process;
end Behavioral;
