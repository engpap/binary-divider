LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY TB_RQ_REGISTER IS
END TB_RQ_REGISTER;
 
ARCHITECTURE behavior OF TB_RQ_REGISTER IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RQ_REGISTER
    PORT(
         CLK			: in std_logic;
         RESET 		: in std_logic;
         CE				: in  std_logic;
         START 		: in  std_logic;
         N				: in  std_logic_vector(31 downto 0);
         SUB			: in  std_logic;
         PARTIAL_SUB : in  std_logic_vector(31 downto 0);
         BIT_IN		: in  std_logic;
         R				: OUT  std_logic_vector(31 downto 0);
         Q				: OUT  std_logic_vector(31 downto 0);
         PARTIAL_R	: OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic;
   signal RESET : std_logic;
   signal CE : std_logic;
   signal START : std_logic;
   signal N : std_logic_vector(31 downto 0);
   signal SUB : std_logic;
   signal PARTIAL_SUB : std_logic_vector(31 downto 0);
   signal BIT_IN : std_logic;

 	--Outputs
   signal R : std_logic_vector(31 downto 0);
   signal Q : std_logic_vector(31 downto 0);
   signal PARTIAL_R : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RQ_REGISTER PORT MAP (
          CLK			=> CLK,
          RESET		=> RESET,
          CE			=> CE,
          START		=> START,
          N				=> N,
          SUB			=> SUB,
          PARTIAL_SUB=> PARTIAL_SUB,
          BIT_IN		=> BIT_IN,
          R				=> R,
          Q				=> Q,
          PARTIAL_R	=> PARTIAL_R
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
      RESET	<='1';
      wait for 100 ns;	
		
		RESET	<='0';
		CE		<=	'1';
      wait for 2*CLK_period;

		START	<=	'1';
		N		<=	"00000000000000000000000000001111";
		D		<=
      wait;
		
   end process;

END;
