library ieee;
use ieee.std_logic_1164.all;
 
-- This testbench proves that when START is set to '1',
-- EOC goes high after 32 clock cicles, while DONE goes high after 33 clock cicles.

entity TB_COUNTER is
end TB_COUNTER;
 
architecture behavior of TB_COUNTER is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component COUNTER
    port(
         CLK	:	in		std_logic;
         RESET :  in		std_logic;
         CE 	:	in		std_logic;
         START :	in		std_logic;
         EOC 	:	out	std_logic;
         DONE 	:	out	std_logic
        );
    end component;
    

   --Inputs
   signal CLK		: std_logic;
   signal RESET	: std_logic;
   signal CE		: std_logic;
   signal START	: std_logic;

 	--Outputs
   signal EOC		: std_logic;
   signal DONE		: std_logic;

   -- Clock period definitions
   constant CLK_period : time := 60 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: COUNTER port map (
          CLK		=> CLK,
          RESET	=> RESET,
          CE		=> CE,
          START	=> START,
          EOC		=> EOC,
          DONE		=> DONE
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		
		RESET	<=	'1';
      wait for 5*CLK_period;	
	
		RESET	<=	'0';
		CE		<=	'1';
		START	<=	'1';
      wait for CLK_period + CLK_period/2;
		
		START	<=	'0';
      wait for 40*CLK_period;
		
		START	<=	'1';
      wait for CLK_period;
		
		START	<=	'0';
      wait;
		
   end process;

end;