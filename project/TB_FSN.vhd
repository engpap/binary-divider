library ieee;
use ieee.std_logic_1164.all;

-- This testbench tests subtractions with negative and positive results.

entity TB_FSN is
end TB_FSN;
 
architecture behavior of TB_FSN is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component FSN
    port(
         X		: in		std_logic_vector(31 downto 0);
         Y		: in		std_logic_vector(31 downto 0);
         BIN	: in		std_logic;
         S		: out		std_logic_vector(31 downto 0);
         BOUT	: out		std_logic
        );
	end component;

   --Inputs
	signal CLK 	: std_logic;
   signal X		: std_logic_vector(31 downto 0);
   signal Y		: std_logic_vector(31 downto 0);
   signal BIN	: std_logic;

 	--Outputs
   signal S 	: std_logic_vector(31 downto 0);
   signal BOUT : std_logic;  
	
	constant CLK_period : time := 60 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSN port map(
          X		=> X,
          Y		=> Y,
          BIN	=> BIN,
          S 	=> S,
          BOUT => BOUT
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

		X  	<= "00000000000000000000000000000000"; --0
		Y		<= "00000000000000000000000000000000"; --0
		BIN 	<= '0';
		-- S:0 BOUT:0
		wait for  5*CLK_period + CLK_period/2;
		
		
		X  	<= "00000000000000000000000000010100"; -- 20
		Y		<= "00000000000000000000000000000010"; -- 2
		BIN 	<= '0';
		-- S:18 BOUT:0
		wait for CLK_period;
		
		X		<= "00000000000000000000000000000010"; -- 2
		Y		<= "00000000000000000000000000010000"; -- 16
		BIN	<= '0';
		-- S: -14(signed) BOUT: 1
		wait for CLK_period;	
		
		-- This testbench proves that clock period must be greater than 35 ns
		X 		<= "00000000000000000000000000011111"; -- 31
		Y		<= "00000000000000000000001001000010"; -- 578
		BIN	<= '1';
		-- S: -548 (signed) BOUT: 1
		wait for CLK_period;	
		
		X 		<= "00000000000000000000000000001010"; -- 10
		Y		<= "00000000000000000000000000000111"; -- 7
		BIN	<= '1';
		-- S:2 BOUT:0
		wait for CLK_period;
			
			
		X 		<= "10010110000111110001101110111111"; -- -1776346177
		Y		<= "11011111111101111111111011111010"; -- -537395462
		BIN	<= '0';
		-- S: -1238950715 BOUT: 1
		wait;	
		
   end process;

end;