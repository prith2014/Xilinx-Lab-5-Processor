----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2017 09:11:36 PM
-- Design Name: 
-- Module Name: tx - Behavioral
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

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           send : in STD_LOGIC;
           rst : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           tx : out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
    type state is (s_idle, s_start, s_data, s_stop);
    signal r_curr : state := s_idle;
    
    -- Register to store data from input char
    signal r_TX_data : std_logic_vector (7 downto 0) := (others => '0');
    
    -- Counter for data state
    signal r_Bit_Index : integer range 0 to 7 := 0;
    
    -- Signals when data is sent in stop state
    signal r_TX_done : std_logic := '0';
    
begin
    
    -- FSM begin
    process(clk, rst) begin
    
        if (rst = '1') then
            r_curr <= s_idle;
            r_TX_data <= (others => '0');
            r_Bit_Index <= 0;
            r_TX_done <= '0';
            
            ready <= '1';
            tx <= '1';
            
        elsif ( rising_edge(clk) and en = '1') then
            case r_curr is
                
                -- Idle state sets ready = 1, transmitter ready to send data
                when s_idle =>
                    ready <= '1';
                    tx <= '1';      -- Logic high for idle
                    r_TX_Done <= '0';
                    r_Bit_Index <= 0;
                    
                    -- Send is pressed, load data and move to start state
                    if send = '1' then
                        r_TX_Data <= char;
                        r_curr <= s_start;
                    else
                        r_curr <= s_idle;
                    end if;
                
                -- Set ready=0 and send start bit
                when s_start =>
                    ready <= '0';
                    tx <= '0';
                    
                    r_curr <= s_data;
                    
                -- Sending data bits
                when s_data =>
                    tx <= r_TX_Data(r_Bit_Index);
                    
                    if r_Bit_Index < 7 then
                        r_Bit_Index <= r_Bit_Index + 1;
                        r_curr <= s_data;
                    else
                        r_Bit_Index <= 0;
                        r_curr <= s_stop;   -- Once all bits are sent, go to stop state
                    end if;
                    
                -- Stop state for one cycle
                when s_stop =>
                    tx <= '1';
                    r_TX_done <= '1';
                    
                    r_curr <= s_idle;
                
                -- When things go wrong
                when others =>
                    r_curr <= s_idle;
                end case;
                
        end if;      
    end process;

end Behavioral;
