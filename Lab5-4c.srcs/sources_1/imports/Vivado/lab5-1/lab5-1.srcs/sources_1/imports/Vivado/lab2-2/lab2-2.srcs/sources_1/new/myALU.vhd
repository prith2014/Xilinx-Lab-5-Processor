----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2017 01:08:48 PM
-- Design Name: 
-- Module Name: myALU - Behavioral
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

entity myALU is
    Port ( 
           clk : in std_logic;
           clk_en : in std_logic;
           A : in std_logic_vector ( 15 downto 0 );
           B : in std_logic_vector ( 15 downto 0 );
           Opcode :  in STD_LOGIC_VECTOR ( 3 downto 0 );
           Y : out std_logic_vector ( 15 downto 0 ));
end myALU;

architecture Behavioral of myALU is
begin

ALU_proc : process(A,B,Opcode,clk_en, clk)
begin
    if ( rising_edge(clk) and clk_en = '1') then
        case Opcode is
            when "0000" =>      -- Addition
                Y <= std_logic_vector(unsigned(A) + unsigned(B));
            when "0001" =>      -- Subtraction
                Y <= std_logic_vector(unsigned(A) - unsigned(B));
            when "0010" =>      -- Increment
                Y <= std_logic_vector(unsigned(A) + 1);
            when "0011" =>      -- Decrement
                Y <= std_logic_vector( unsigned(A) - 1);
            when "0100" =>      -- 0 - A
                Y <= std_logic_vector(0 - unsigned(A));
            when "0101" =>      -- Shift Logical left
                Y <= std_logic_vector(unsigned(A) sll 1);
            when "0110" =>      -- Shift right logical
                Y <= std_logic_vector(unsigned(A) srl 1);
            when "0111" =>      -- Shift right arithmetic
                Y <= std_logic_vector(shift_right( signed(A), 1));
            when "1000" =>      -- A and B
                Y <= A and B;
            when "1001" =>      -- A or B
                Y <= A or B;
            when "1010" =>      -- A xor B
                Y <= A xor B;
            when "1011" =>      -- A < B (signed)
                if ( signed(A) < signed(B)) then
                    Y <= "0000000000000001";
                else
                    Y <= (others => '0');
                end if;
            when "1100" =>      -- A > B (signed)
                if ( signed(A) > signed(B)) then
                    Y <= "0000000000000001";
                else
                    Y <= (others => '0');
                end if;
            when "1101" =>      -- A = B 
                if ( A = B ) then
                    Y <= "0000000000000001";
                else
                    Y <= (others => '0');
                end if;
            when "1110" =>      -- A < B
                if ( A < B ) then
                    Y <= "0000000000000001";
                else
                    Y <= (others => '0');
                end if;                
            when "1111" =>      -- A > B
                if ( A > B ) then
                    Y <= "0000000000000001";
                else
                    Y <= (others => '0');
                end if;
            when others =>
                Y <= (others => '0');
        end case;
    end if;
    
end process;

end Behavioral;
