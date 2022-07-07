library ieee;
use ieee.std_logic_1164.all;

entity DIVIDER is
	generic(SIZE:integer:=32; COUNTER_SIZE:integer:=5);
	port(
			CLK				:	in		std_logic;
			RESET				:	in		std_logic;
			START				:	in		std_logic;
			N					:	in		std_logic_vector(SIZE-1 downto 0); -- dividend
			D					:	in		std_logic_vector(SIZE-1 downto 0); -- divisor
			Q					:	out	std_logic_vector(SIZE-1 downto 0); -- quotient
			R					:	out	std_logic_vector(SIZE-1 downto 0); -- remainder
			DONE				:	out	std_logic;
			ERROR				:	out	std_logic
	);
end DIVIDER;

architecture RTL of DIVIDER is

	component RQ_REGISTER
		generic(SIZE:integer);
		port(
				CLK			:	in		std_logic;
				RESET			:	in		std_logic;
				CE				:	in		std_logic;
				START			:	in		std_logic;
				N				:	in		std_logic_vector(SIZE-1 downto 0);
				SUB			:	in		std_logic;
				PARTIAL_SUB	:	in		std_logic_vector(SIZE-1 downto 0);
				BIT_IN		:	in		std_logic;
				R				:	out	std_logic_vector(SIZE-1 downto 0);
				Q				:	out	std_logic_vector(SIZE-1 downto 0);
				PARTIAL_R	:	out	std_logic_vector(SIZE-1 downto 0)
		);
	end component;
	
	component FSN
		generic(SIZE:integer);
		port(
				X				:	in		std_logic_vector(SIZE-1 downto 0);
				Y				:	in		std_logic_vector(SIZE-1 downto 0);
				BIN			:	in		std_logic;
				S				:	out	std_logic_vector(SIZE-1 downto 0);
				BOUT			:	out	std_logic
		);
	end component;
	
	component COUNTER
		generic(SIZE:integer);
		port( 
				CLK			:	in		std_logic;
				RESET			:	in		std_logic;	
				CE				:	in		std_logic;
				START			:	in		std_logic;
				EOC			:	out	std_logic;
				DONE			:	out	std_logic
		);
	end component;
	
	component EQUAL_COMPARATOR
		generic(SIZE:integer);
		port ( 
				CLK			:	in		std_logic;
				RESET			:	in		std_logic;
				START			:	in		std_logic;
				X  			:	in		std_logic_vector(SIZE-1 downto 0); 
				Y  			:	in		std_logic_vector(SIZE-1 downto 0); 
				ERROR			:	out	std_logic      
		);
	end component;
		
	--Constants
	constant ZERO			:	std_logic_vector(SIZE-1 downto 0) := (others=>'0'); -- To check if divisor equals zero
	
	--Signals
	signal TEOC				:	std_logic;
	signal TERROR			:	std_logic;
	signal TSUB				:	std_logic; 									-- Borrow signal from Subtractor (FSN)
	signal TPARTIAL_SUB	:	std_logic_vector(SIZE-1 downto 0); 	-- Difference from FSN
	signal TPARTIAL_R		:	std_logic_vector(SIZE-1 downto 0); 	-- Partial remainder from RQ_REGISTER
	signal TR				:	std_logic_vector(SIZE-1 downto 0);
	signal TQ				:	std_logic_vector(SIZE-1 downto 0);
	
begin

	instance_counter:	COUNTER
	generic map(SIZE=>COUNTER_SIZE)
	port map(
				CLK			=>	CLK,
				RESET			=> RESET,
				CE				=>	not(TERROR),
				START			=> START,
				EOC			=>	TEOC,
				DONE			=> DONE
	);
	-- Counter is enabled (CE='1') when there is no error.
	
	instance_RQ_register: RQ_REGISTER
	generic map(SIZE=>SIZE)
	port map(
				CLK			=>	CLK,
				RESET			=> RESET,
				CE				=>	not(TEOC),
				START			=> START,
				N				=>	N,
				SUB			=>	TSUB,
				PARTIAL_SUB	=>	TPARTIAL_SUB,
				BIT_IN		=>	TSUB,
				R				=> TR,
				Q				=> TQ,
				PARTIAL_R	=>	TPARTIAL_R
	);
	-- Writing in registers is enabled (CE='1') when there is no error.
	-- BIT_IN is complemented inside RQ_REGISTER module.

	instance_subtractor: FSN
	generic map(SIZE=>SIZE)
	port map(
				X				=>	TPARTIAL_R,
				Y				=>	D,
				BIN			=>	'0',
				S				=>	TPARTIAL_SUB,
				BOUT			=>	TSUB
	);
	-- Project's hypothesis: input borrow is '0'.
	
	instance_equal_zero: EQUAL_COMPARATOR
	generic map(SIZE=>SIZE)
	port map(
				CLK			=>	CLK,
				RESET			=>	RESET,
				START			=>	START,
				X				=> D,
				Y				=>	ZERO,
				ERROR			=>	TERROR
	);
	-- The input binary word Y is ZERO, so the system can signal ERROR when divisor is equal to zero.
		
	ERROR	<= TERROR;
	R		<=	TR;
	Q		<=	TQ;

end RTL;