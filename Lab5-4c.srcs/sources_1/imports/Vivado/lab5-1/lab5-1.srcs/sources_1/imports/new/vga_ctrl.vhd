----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2017 04:17:12 PM
-- Design Name: 
-- Module Name: vga_ctrl - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_ctrl is
    Port ( clk : in STD_LOGIC;
           clk_en : in STD_LOGIC;
           hcount : out STD_LOGIC_VECTOR (9 downto 0);
           vcount : out STD_LOGIC_VECTOR (9 downto 0);
           vid : out STD_LOGIC;
           hs : out STD_LOGIC;
           vs : out STD_LOGIC);
end vga_ctrl;

architecture Behavioral of vga_ctrl is
    -- Signals
    signal r_hcount : std_logic_vector (9 downto 0) := (others => '0');
    signal r_vcount : std_logic_vector (9 downto 0) := (others => '0');
    

begin
    process (clk, clk_en) begin
        if rising_edge(clk) and clk_en = '1' then
            -- Increment counters
            -- if hcount < 799
            if (r_hcount < "1100011111") then
                r_hcount <= std_logic_vector(unsigned(r_hcount) + 1);
            else
                r_hcount <= (others => '0');
                
                -- if vcount < 524
                if (r_vcount < "1000001100") then
                    r_vcount <= std_logic_vector(unsigned(r_vcount) + 1);
                else
                    r_vcount <= (others => '0');
                end if;
                
            end if;
        
            -- if r_hcount < 639 and r_vcount < 479
            if (r_hcount < "1001111111") and (r_vcount < "0111011111") then
                vid <= '1';                
                -- Output colors
            else
                vid <= '0';
                -- All colors are black                
            end if;
            
            -- if 656 < r_hcount < 751
            if (r_hcount > "1010010000") and (r_hcount < "1011101111") then
                hs <= '0';
            else
                hs <= '1';
            end if;

            
            --if 490 < r_vcount < 491
            if (r_vcount > "0111101001") and (r_vcount < "0111101011") then
                vs <= '0';
            else
                vs <= '1';
            end if;
            
        end if;
    end process;

    hcount <= r_hcount;
    vcount <= r_vcount;

end Behavioral;
