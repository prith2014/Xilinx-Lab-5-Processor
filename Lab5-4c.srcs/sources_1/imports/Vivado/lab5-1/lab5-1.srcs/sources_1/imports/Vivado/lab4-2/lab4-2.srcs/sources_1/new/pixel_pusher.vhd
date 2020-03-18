----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/25/2017 09:09:47 PM
-- Design Name: 
-- Module Name: pixel_pusher - Behavioral
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

entity pixel_pusher is
    Port ( clock : in STD_LOGIC;
           clock_en : in STD_LOGIC;
           VS : in STD_LOGIC;
           pixel : in STD_LOGIC_VECTOR (15 downto 0);
           hcount : in STD_LOGIC_VECTOR (5 downto 0);
           vcount : in STD_LOGIC_VECTOR (5 downto 0);
           vid : in STD_LOGIC;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           addr : out STD_LOGIC_VECTOR (11 downto 0));
end pixel_pusher;

architecture Behavioral of pixel_pusher is
    --constant width : std_logic_vector (9 downto 0) := "0111100000";  -- width = 480
    constant width : std_logic_vector (6 downto 0) := "1000000";    -- width = 64
    
    signal r_addr : std_logic_vector (11 downto 0) := (others => '0');
begin
    process(clock) begin
        if (rising_edge(clock) and clock_en = '1') then
            
            if (VS = '0') then
                r_addr <= (others => '0');
            end if;
            
            if (vid = '1') then
            
                if (hcount <= width) then
                    r_addr <= std_logic_vector(unsigned(r_addr) + 1);
                end if;
                
                if (hcount < width) then
                    R <= pixel(15 downto 11);
                    G <= pixel(10 downto 5);
                    B <= pixel(4 downto 0);
                else
            
                    R <= (others => '0');
                    G <= (others => '0');
                    B <= (others => '0');
                end if;
             end if;
            
        end if;
    end process;
    
    addr <= r_addr;
end Behavioral;
