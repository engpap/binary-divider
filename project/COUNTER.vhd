library ieee;
use ieee.std_logic_1164.all;

entity COUNTER is
	generic(SIZE:integer:=5);
		port( 
				CLK				:	in		std_logic;
				RESET				:	in		std_logic;
				CE					:	in		std_logic; -- To enable counting
				START				:	in		std_logic; -- To start counting
				EOC				:	out	std_logic; -- To signal end of count
				DONE				:	out 	std_logic  -- To singal end of algorithm
		);
end COUNTER;

architecture RTL of COUNTER is

	component FSN
		generic(SIZE:integer);
		port(
				X				:	in 	std_logic_vector(SIZE-1 downto 0);
				Y				:	in 	std_logic_vector(SIZE-1 downto 0);
				BIN			:	in 	std_logic;
				S				:	out	std_logic_vector(SIZE-1 downto 0);
				BOUT			:	out 	std_logic
		);
	end component;
	
	component COUNT_MANAGER
		generic(SIZE:integer);
			port(
					CLK		:	in 	std_logic;
					RESET		:	in 	std_logic;
					CE			:	in		std_logic;
					START		:	in 	std_logic;
					COUNT_IN	: 	in 	std_logic_vector(SIZE-1 downto 0);
					COUNT_OUT:	out 	std_logic_vector(SIZE-1 downto 0);
					EOC		:	out	std_logic;
					DONE		:	out 	std_logic
			);
	end component;
	
	-- Constants
	constant ONE			:	std_logic_vector(SIZE-1 downto 0) := ( 0 => '1', others=> '0' ); -- To decrement one to count value
	
	-- Signals
	signal TCOUNT_IN		:	std_logic_vector(SIZE-1 downto 0);
	signal TCOUNT_OUT		:	std_logic_vector(SIZE-1 downto 0);

	begin
					
		instance_FSN: FSN
		generic map(SIZE=>SIZE)
		port map(
					X			=>	TCOUNT_OUT,
					Y			=>	ONE,
					BIN		=>	'0',
					S			=>	TCOUNT_IN,
					BOUT		=>	open
		);
		
		instance_COUNT_MAN: COUNT_MANAGER
		generic map(SIZE=>SIZE)
		port map(
					CLK		=>	CLK,
					RESET		=>	RESET,
					CE			=>	CE,
					START		=>	START,
					COUNT_IN => TCOUNT_IN,
					COUNT_OUT=> TCOUNT_OUT,
					EOC		=> EOC,
					DONE		=>	DONE
		);
		
end RTL;