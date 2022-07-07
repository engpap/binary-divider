library ieee;
use ieee.std_logic_1164.all;
 
-- This testbench tests if the component set ERROR to '1' when input binary words are the same.

entity TB_EQUAL_COMPARATOR is
end TB_EQUAL_COMPARATOR;
 
architecture behavior of TB_EQUAL_COMPARATOR is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component EQUAL_COMPARATOR
    port(
         CLK 	:	in		std_logic;
         RESET :	in		std_logic;
         START :	in		std_logic;
         X 		:	in		std_logic_vector(31 downto 0);
         Y 		:	in 	std_logic_vector(31 downto 0);
         ERROR :	out	std_logic
        );
    end component;
    

   --Inputs
   signal CLK 		: std_logic;
   signal RESET 	: std_logic;
   signal START 	: std_logic;
   signal X 		: std_logic_vector(31 downto 0);
   signal Y 		: std_logic_vector(31 downto 0);

 	--Outputs
   signal ERROR : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 60 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EQUAL_COMPARATOR port map (
          CLK		=> CLK,
          RESET	=> RESET,
          START	=> START,
          X			=> X,
          Y			=> Y,
          ERROR	=> ERROR
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
      wait for 2*CLK_period;	
	    
		RESET	<=	'0';
		START	<=	'0';
      wait for 2*CLK_period + CLK_period/2; -- by this way, START goes high when CLK goes high	
		
		START	<=	'1';
		X		<=	"00000000000000000000000000001111";
		Y		<=	"00000000000000000000000000001111";
      wait for CLK_period;
		START<='0';
		wait for CLK_period*5;
		
		START	<=	'1';
		X		<=	"00000000000000000000000000001011";
		Y		<=	"00000000000000000000000000001111";
      wait for CLK_period;
		START	<='0';
		wait for CLK_period*5;

		START	<=	'1';
		X		<=	"00000000000000000000000000000000";
		Y		<=	"00000000000000000000000000001111";
      wait for CLK_period;
		START	<='0';
		wait;
		
   end process;

end;