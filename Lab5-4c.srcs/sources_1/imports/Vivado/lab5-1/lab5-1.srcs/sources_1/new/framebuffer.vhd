----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2017 08:56:12 PM
-- Design Name: 
-- Module Name: framebuffer - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity framebuffer is
generic (
	DATA : integer := 16;
	ADDR : integer := 12
);
    Port ( 
        clk1 : in STD_LOGIC;
		
		-- Port A
		en1 :  in STD_LOGIC;
		wr_en1 : in STD_LOGIC;
		addr1 : in STD_LOGIC_VECTOR (11 downto 0);
		din1 : in STD_LOGIC_VECTOR (15 downto 0);
		dout1 : out STD_LOGIC_VECTOR (15 downto 0);
		
		-- Port B
		en2 : in STD_LOGIC;
        addr2 : in STD_LOGIC_VECTOR (11 downto 0);
        dout2 : out STD_LOGIC_VECTOR (15 downto 0)
        );
end framebuffer;

architecture Behavioral of framebuffer is
-- Memory of 4096 16-bit words
type mem_type is array ( (2**ADDR)-1 downto 0) of std_logic_vector (DATA-1 downto 0);
shared variable memSignal : mem_type;

begin

-- Port A
process(clk1, en1)
begin
	if (rising_edge(clk1) and en1 = '1') then
			if (wr_en1 = '1') then
				memSignal(conv_integer(addr1)) := din1;
			end if;
			
			dout1 <= memSignal(conv_integer(addr1));
	end if;
end process;

-- Port B
process(clk1, en2)
begin
    if (rising_edge(clk1) and en2 = '1') then
        dout2 <= memSignal(conv_integer(addr2));
    end if;
end process;

end Behavioral;
