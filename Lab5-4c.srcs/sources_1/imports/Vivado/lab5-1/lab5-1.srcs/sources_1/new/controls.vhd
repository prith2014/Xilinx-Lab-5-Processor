----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2017 12:38:26 PM
-- Design Name: 
-- Module Name: controls - Behavioral
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

entity controls is
    Port (
	-- Timing Signals
    clk, en, rst : in std_logic;
	
	-- Register File IO
	rID1, rID2 : out std_logic_vector (4 downto 0);
	wr_enR1, wr_enR2 :  out std_logic;
	regrD1, regrD2 : in std_logic_vector (15 downto 0) := (others => '0');
	regwD1, regwD2 : out std_logic_vector (15 downto 0);
	
	-- Framebuffer IO
	--fbRST : out std_logic;
	fbAddr1 : out std_logic_vector (11 downto 0);
	fbDin1 : in std_logic_vector (15 downto 0);
	fbDout1 : out std_logic_vector (15 downto 0);
	fb_wr_en : out std_logic;
	
	-- Instruction Memory IO
	irAddr : out std_logic_vector (13 downto 0) := (others => '0');
	irWord : in std_logic_vector (31 downto 0);
	
	-- Data Memory IO
	dAddr : out std_logic_vector (14 downto 0) := (others => '0');
	d_wr_en : out std_logic;
	dOut : out std_logic_vector (15 downto 0);
	dIn : in std_logic_vector (15 downto 0) := (others => '0');
	
	-- ALU IO
	aluA, aluB : out std_logic_vector (15 downto 0);
	aluOp : out std_logic_vector (3 downto 0);
	aluResult : in std_logic_vector (15 downto 0);
	
	-- UART IO
	ready, newChar : in std_logic;
	send : out std_logic;
	charRec : in std_logic_vector (7 downto 0);
	charSend : out std_logic_vector (7 downto 0)
    );
end controls;

architecture Behavioral of controls is
    type state is (fetch, decode,decode_delay, Rops, Iops, Jops, jr, recv, rpix, wpix, send_state, calc,
                   equals, nequal, ori, lw, sw, jmp, jal, calc_delay, store, finish, lw_delay, fetch_delay, send_state_delay,
                   calc_delay2, rpix_delay );
    signal r_curr : state := fetch;

    signal curr_pcAddr : std_logic_vector (15 downto 0) := (others => '0');
    --signal irMem_PC : std_logic_vector (31 downto 0) := (others => '0');
    signal reg1_addr : std_logic_vector (4 downto 0) := (others => '0');
    signal reg2_addr : std_logic_vector (4 downto 0) := (others => '0');
    signal reg3_addr : std_logic_vector (4 downto 0) := (others => '0');
    --signal reg1 : std_logic_vector (15 downto 0) := (others => '0');
    --signal reg2 : std_logic_vector (15 downto 0):= (others => '0');
    --signal reg3 : std_logic_vector (15 downto 0):= (others => '0');
    --signal J_imm : std_logic_vector (15 downto 0) := (others => '0');
    signal aluResult_sig : std_logic_vector (15 downto 0) := (others => '0');
    signal imm_sig : std_logic_vector (15 downto 0) := (others => '0');
    signal dMem_sig : std_logic_vector (15 downto 0) := (others => '0');
    signal opcode : std_logic_vector (4 downto 0) := (others => '0');
begin

process(clk, en, rst)
variable I : integer := 0;
begin
	if rst = '1' then
		r_curr <= fetch;
	elsif (rising_edge(clk) and en = '1') then
		case r_curr is
			when fetch =>
			     -- get current pc from reg into signal
			     rID1 <= "00001";        -- read from reg[1], pc reg
			     --curr_pcAddr <= regrD1;      -- signal curr_pc = reg[1]
			     
			     --r_curr <= decode;       -- next state = decode			     
                 r_curr <= fetch_delay;
                 
            when fetch_delay =>
                 curr_pcAddr <= regrD1;
                 irAddr <= curr_pcAddr(13 downto 0); 
                 r_curr <= decode;

			when decode =>
			     -- store irMem[pc_sig] into signal
			     
			     irAddr <= curr_pcAddr(13 downto 0);     -- Address where current pc is located in irMem
			     r_curr <= decode_delay;                 -- Need 1 cycle delay
			     
			     --irMem_PC <= irWord;         -- store irMem[pc_signal) into signal
			     
			when decode_delay =>
			     --irMem_PC <= irWord;         -- store irMem[pc_signal) into signal
			     rID1 <= "00001";            -- Writing into pc reg
			     wr_enR1 <= '1';             -- write enable
			     regwD1 <= std_logic_vector(unsigned(curr_pcAddr) + 1);        -- store pc_signal+1 to reg1
			     
			     -- IF statements
			     if ( (irWord(31 downto 30) = "00") or ( irWord(31 downto 30) = "01") ) then
			         r_curr <= Rops;
			     elsif (irWord(31 downto 30) = "10") then
			         r_curr <= Iops;
			     else
			         r_curr <= Jops;
			     end if;
			     
			when Rops =>
			     wr_enR1 <= '0';             -- De-assert write signal from decode
			     
			     -- 31 to 27 = opcode
			     -- 26 to 22 = reg1
			     -- 21 to 17 = reg2
			     -- 16 to 12 = reg3
			     -- rest unused
			     opcode <= irWord(31 downto 27);
			     reg1_addr <= irWord(26 downto 22);
			     reg2_addr <= irWord(21 downto 17);
			     reg3_addr <= irWord(16 downto 12);
			     
			     -- Fetching reg2
			     rID1 <= irWord(21 downto 17);
			     --reg2 <= regrD1;
			     -- Fetching reg3
			     rID2 <= irWord(16 downto 12);
			     --reg3 <= regrD2;
			   
			     if ( (irWord(31 downto 27) = "01101")) then
                     r_curr <= jr;
                 elsif (irWord(31 downto 27) = "01100") then
                     r_curr <= recv;
                 elsif (irWord(31 downto 27) = "01111") then
                     r_curr <= rpix;
                 elsif (irWord(31 downto 27) = "01110") then
                     r_curr <= wpix;
                 elsif (irWord(31 downto 27) = "01011") then
                     r_curr <= send_state;
                 else
                     r_curr <= calc;
                 end if;
			     
			when Iops =>                     
                 wr_enR1 <= '0';                -- De-assert write signal from decode
			     -- 31 to 27 = opcode
                 -- 26 to 22 = reg1
                 -- 21 to 17 = reg2
                 -- 16 to 1 = imm   (16 bit)
                 
                 reg1_addr <= irWord(26 downto 22);
                 
			     -- Fetching reg2
                 --rID1 <= irWord(21 downto 17);
                 --reg2 <= regrD1;
                 -- fetch reg1
                 --rID2 <= irWord(26 downto 22);
                 --reg1 <= regrD2;
                 
                 -- fetch reg1
                 rID1 <= irWord(26 downto 22);
                 --reg1 <= regrD1;
                 -- fetch reg2
                 rID2 <= irWord(21 downto 17);
                 --reg2 <= regrD2;
                 
                 imm_sig <= irWord(16 downto 1);      -- Store imm into imm_sig
                 
			     if ( (irWord(29 downto 27) = "000")) then
                    r_curr <= equals;
                 elsif ( (irWord(29 downto 27) = "001")) then
                    r_curr <= nequal;
                 elsif ( (irWord(29 downto 27) = "010")) then
                    r_curr <= ori;
                 elsif ( (irWord(29 downto 27) = "011")) then
                   r_curr <= lw;
                 else
                    r_curr <= sw;
                 end if;
                      
			when Jops =>             
                 wr_enR1 <= '0';                    -- De-assert write signal from decode
			     
				 -- 31 to 27 = opcode
				 -- 26 to 11 = imm
				 
				 --J_imm <= irWord(26 downto 11);
				 
			     if ( (irWord(31 downto 27) = "11000")) then
                     r_curr <= jmp;
                 elsif (irWord(31 downto 27) = "11001") then
                     r_curr <= jal;
                 end if;
                 
            when calc =>
                
                 aluA <= regrD1;
                 aluB <= regrD2;
                 --aluOp <= irWord(30 downto 27);
                 
                 case opcode is
                    when "00000" => aluOp <= x"0";  --add
                    when "00001" => aluOp <= x"1";  --sub
                    when "00010" => aluOp <= x"5";  --sll
                    when "00011" => aluOp <= x"6";  --srl
                    when "00100" => aluOp <= x"7";  --sra
                    when "00101" => aluOp <= x"8";  --and
                    when "00110" => aluOp <= x"9";  --or
                    when "00111" => aluOp <= x"A";  --xor
                    when "01000" => aluOp <= x"B";  --slt
                    when "01001" => aluOp <= x"C";  --sgt
                    when "01010" => aluOp <= x"D";  --seq
                    when others => aluOp <= x"0";   -- just add
                 end case;
                 r_curr <= calc_delay;
                 
                
		    when calc_delay =>
		         -- Delay required for ALU results
		         --aluResult_sig <= aluResult;
		         r_curr <= calc_delay2;
		         
		    when calc_delay2 =>     
		        
		         aluResult_sig <= aluResult;
		         r_curr <= store;
		        
		    when store =>
		         rID1 <= reg1_addr;
		         wr_enR1 <= '1';
		         regwD1 <= aluResult_sig;
		         
		         r_curr <= finish;
		         
		    when jr =>
		         -- Read reg and store into aluResult_sig
		         -- read register
			     rID1 <= irWord(26 downto 22);
                 aluResult_sig <= regrD1;
                 
                 r_curr <= store;
                 
            when recv =>
                -- store char Rec into alu result
                aluResult_sig <= "00000000" & charRec;
                
                if (newChar = '0') then
                    r_curr <= recv;
                    -- aluResult_sig <= "00000000" & charRec; if it dont work
                else
                    r_curr <= store;
                end if;
                
            when rpix =>
                -- Read fb mem at the value of reg2
                fbAddr1 <= regrD1(11 downto 0);
                --aluResult_sig <= fbDin1;
                
                --r_curr <= store;
                r_curr <= rpix_delay;
                
            when rpix_delay=>
                aluResult_sig <= fbDin1;
            
                r_curr <= store;
                               
            when wpix =>
            
                -- fetch reg1
			    rID1 <= irWord(26 downto 22);
                --reg1 <= regrD1;
                
                -- Store reg2 into fb[reg1]
                fbAddr1 <= regrD1(11 downto 0);
                fbDout1 <= regrD2;
                fb_wr_en <= '1';
                
                r_curr <= finish;
                
            when send_state =>
            
                send <= '1';
                -- fetch reg1 
                rID1 <= irWord(26 downto 22);
                --reg1 <= regrD1;
                r_curr <= send_state_delay;
                --charSend <= regrD1(7 downto 0);
                
                --if (ready = '1') then
                --    r_curr <= finish;
                --else
                --    r_curr <= send_state;
                --end if;
                
            when send_state_delay =>
                charSend <= regrD1(7 downto 0);
            
                if (ready = '1') then
                    r_curr <= finish;
                else
                    r_curr <= send_state;
                end if;                
                
            when equals => 
            
                if (regrD1 = regrD2) then
                    aluResult_sig <= imm_sig;
                    --reg1 <= curr_pcAddr;
                    reg1_addr <= "00001";                  
                end if;
                
                r_curr <= store;
                
            when nequal =>
                
                if (regrD1 /= regrD2) then
                    aluResult_sig <= imm_sig;
                    --reg1 <= curr_pcAddr; 
                    reg1_addr <= "00001"; 
                end if;
                
                r_curr <= store;
                
            when ori =>
            
                --aluResult_sig <= imm_sig or reg2;
                
                for i in 0 to 15 loop
                    aluResult_sig(i) <= imm_sig(i) or regrD2(i);
                end loop;
                
                r_curr <= store;
                
            when lw =>
                -- Store dMem[reg2 + imm] to aluresult_sig
                dAddr <= std_logic_vector(unsigned(regrD2(14 downto 0)) + unsigned(imm_sig(14 downto 0)));
                r_curr <= lw_delay;
                
            when lw_delay =>
                -- Delay required for reading dMem
                aluResult_sig <= dIn;
                r_curr <= store;
                
            when sw =>
                -- store reg1 into dMem[reg2+imm]
                dAddr <= std_logic_vector(unsigned(regrD2(14 downto 0)) + unsigned(imm_sig(14 downto 0)));
                d_wr_en <= '1';
                dOut <= regrD1;
                
                r_curr <= finish;
                
            when jmp =>
                -- Set value of pc register to imm
                rID1 <= "00001";        -- Writing into pc reg
                wr_enR1 <= '1';         -- Write enable = 1
                regwD1 <= irWord(26 downto 11);        -- Store imm address into pc reg
                
                r_curr <= finish;
                
            when jal =>
                -- Set the value of the ra register to the value of the pc reg
                rID1 <= "00010";        -- Writing into ra reg
                wr_enR1 <= '1';         -- write enable of reg1
                regwD1 <= curr_pcAddr;      -- Write the value of curr_pc to ra reg
                
                rID2 <= "00001";        -- Writing into pc reg
                wr_enR2 <= '1';         -- write enable of reg2
                regwD2 <= irWord(26 downto 11);        -- Write the value of imm to pc reg
                
                r_curr <= finish;       -- go to finish
                
            when finish =>
                -- De-assert any required control signals
                wr_enR1 <= '0';
                wr_enR2 <= '0';
                d_wr_en <= '0';
                fb_wr_en <= '0';
                
                r_curr <= fetch;
		         
		end case;
	end if;

end process;

end Behavioral;
