----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2017 11:12:54 PM
-- Design Name: 
-- Module Name: clock_div - Behavioral
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


entity clock_div_VGA is
    Port ( 
        clk : in STD_LOGIC;
        clk_div : out STD_LOGIC
    );
end clock_div_VGA;

architecture Behavioral of clock_div_VGA is
    signal prescaler : std_logic_vector (2 downto 0) := (others => '0');
    signal clk_2Hz : std_logic := '0';
begin

    div_proc: process(clk)   
    begin
        if rising_edge(clk) then
            if (prescaler = "100") then	-- counter to 5
                prescaler <= (others => '0');
                clk_div <= '1';
                
            else
                prescaler <= std_logic_vector( unsigned(prescaler) + 1);
                clk_div <= '0';
            end if;
         end if;  
    end process div_proc;

end Behavioral;
