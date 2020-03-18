----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2017 03:53:37 PM
-- Design Name: 
-- Module Name: regs - Behavioral
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

entity regs is
    Port ( clk, en, rst : in STD_LOGIC;
           id1, id2 : in STD_LOGIC_VECTOR (4 downto 0);     -- Addresses
           wr_en1, wr_en2 : in STD_LOGIC;
           din1, din2 : in STD_LOGIC_VECTOR (15 downto 0);
           dout1, dout2 : out STD_LOGIC_VECTOR (15 downto 0));
end regs;

architecture Behavioral of regs is
-- Create 32 16-bit word registers
--type reg_type is array (31 downto 0) of std_logic_vector (15 downto 0);
--signal registers : reg_type;

--subtype word_t is std_logic_vector(15 downto 0);
--type reg_type is array (31 downto 0) of word_t;
--signal registers : reg_type;

type reg_type is array (0 to 31) of std_logic_vector(15 downto 0);
signal registers : reg_type := (others => x"0000");


signal id1_int : integer := 0;
signal id2_int : integer := 0;

begin

id1_int <= To_integer(unsigned(id1));
id2_int <= To_integer(unsigned(id2));

dout1 <= registers(id1_int);      -- dout1 = registers(id1)
dout2 <= registers(id2_int);      -- dout2 = registers(id2)

process (clk, en, rst) begin
    
    if (rst = '1') then                                 -- if reset = 1
        --registers <= (others => x"0000");           -- registers(all) = 0
        for I in 0 to 31 loop
            registers(I) <= (others => '0');
        end loop;
        
    elsif (rising_edge(clk) and en = '1') then
        registers(0) <= (others => '0');                    -- registers(0) = 0       
        
        if (wr_en1 = '1') then                              -- if wr_en1 = 1
            registers(id1_int) <= din1;   -- registers(id1) = din1
        end if;
        
        if (wr_en2 = '1') then                              -- if wr_en2 = 1
            registers(id2_int) <= din2;   -- registers(id2) = din2
        end if;        
            
    end if;
    
end process;
end Behavioral;
