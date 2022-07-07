library ieee;
use ieee.std_logic_1164.all;
 
-- This testbench tests the top-module using particular values of N and D.

entity TB_DIVIDER is
end TB_DIVIDER;
 
architecture behavior of TB_DIVIDER is
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component DIVIDER
    port(
         CLK 		: in		std_logic;
         RESET 	: in  	std_logic;
         START 	: in  	std_logic;
         N 			: in  	std_logic_vector(31 downto 0);
         D 			: in  	std_logic_vector(31 downto 0);
         Q 			: out		std_logic_vector(31 downto 0);
         R 			: out		std_logic_vector(31 downto 0);
         DONE 		: out		std_logic;
         ERROR 	: out		std_logic
        );
    end component;

   --Inputs
   signal CLK 		: std_logic;
   signal RESET	: std_logic;
   signal START	: std_logic;
   signal N			: std_logic_vector(31 downto 0);
   signal D			: std_logic_vector(31 downto 0);

 	--Outputs
   signal Q 		: std_logic_vector(31 downto 0);
   signal R			: std_logic_vector(31 downto 0);
   signal DONE		: std_logic;
   signal ERROR	: std_logic;
	
   -- Clock period definitions
   constant CLK_period : time := 60 ns; 
	-- OBSERVATION:	The Divider could also work with a smaller clock period,
	-- 					but the FSN requires a clock period of at least 55 ns.
	constant WAIT_BENCH : time	:=	CLK_period*33;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DIVIDER port map (
          CLK		=> CLK,
          RESET 	=> RESET,
          START 	=> START,
          N			=> N,
          D			=> D,
          Q			=> Q,
          R			=> R,
          DONE		=> DONE,
          ERROR	=> ERROR
        );

   -- Clock process definitions
   CLK_process	:	process
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
      wait for 3*CLK_period;
		
		RESET	<=	'0';
		START	<=	'0';
		wait for 3*CLK_period;
				
		--	Division example N>D
		N<="00000000000000000000000000001111"; -- 15
		D<="00000000000000000000000000000011"; -- 3
		-- Q:15 R:1
		START	<=	'1';
		wait for CLK_period;
		START	<='0';
		wait for WAIT_BENCH;

		--	Division example N>>D
		N	<=	"11111111111111111111111111111111"; -- 4294967295
		D	<=	"00000000000000000000000000000011"; -- 3
		-- Q:1431655765  R:0
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
      wait for WAIT_BENCH;
		
		--	Division example N=D
		N	<=	"00000000000000000000000001001101"; -- 77
		D	<=	"00000000000000000000000001001101"; -- 77
		-- Q:1 R:0
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
      wait for WAIT_BENCH;		
		
		--	Division example N<<D
		N	<=	"00000000000000000000000001001100"; -- 76
		D	<=	"00000000000000100000000001001101"; -- 131149
		--Q:0 R:76
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
      wait for WAIT_BENCH;
		
		--	Division example N<D with big values
		N	<=	"11110000000100000000000001001100"; -- 4027580492
		D	<=	"11111111111111111111111111111111"; -- 4294967295
		-- Q:0 R:4027580492
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
      wait for WAIT_BENCH;
		
		
		--	Division example N=0 e D>0
		N	<=	"00000000000000000000000000000000"; -- 0
		D	<=	"00000001011000100111100110111101"; -- 23230909
		-- Q:0 R:0
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
      wait for WAIT_BENCH;
		
		--	Division example N=0 e D=0
		N	<=	"00000000000000000000000000000000"; -- 0
		D	<=	"00000000000000000000000000000000"; -- 0
		-- ERROR:1
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
      wait for WAIT_BENCH;
		
		--	Division example N>0 e D=0
		N	<=	"00000000000000000000000000001001"; -- 9
		D	<=	"00000000000000000000000000000000"; -- 0
		-- ERROR:1
		START	<=	'1';
		wait for CLK_period;
		START	<=	'0';
		-- Wait for less time than WAIT_BENCH because this test case should return ERROR.
		-- It is not useful to hold on for more nanoseconds because Q and R will not have significant values.
		wait for 3*CLK_PERIOD;
		
		--	Division example N<D
		N	<=	"00000000000000000000000000001001"; -- 9
		D	<=	"00000000000000000000000000010000"; -- 16
		START	<=	'1';
		-- Q:0 R:9
		wait for CLK_period;
		START	<=	'0';
		wait;
			
   end process;

end;
