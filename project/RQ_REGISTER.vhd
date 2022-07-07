library ieee;
use ieee.std_logic_1164.all;

entity RQ_REGISTER is
	generic(SIZE:integer:=32);
	port(
			CLK			:	in		std_logic;
			RESET			:	in 	std_logic;
			CE				:	in 	std_logic; 									-- To enable writing in registers
			START			:	in 	std_logic; 									-- To load N in Q's registers
			N				:	in 	std_logic_vector(SIZE-1 downto 0);
			SUB			:	in 	std_logic;									-- To load PARTIAL_SUB in R's registers
			PARTIAL_SUB	:	in 	std_logic_vector(SIZE-1 downto 0); 	-- This value is the input of R's registers
			BIT_IN		:	in 	std_logic;									-- Bit loaded in the rightmost register
			R				:	out 	std_logic_vector(SIZE-1 downto 0);
			Q				:	out 	std_logic_vector(SIZE-1 downto 0);
			PARTIAL_R	:	out 	std_logic_vector(SIZE-1 downto 0)
	);
end RQ_REGISTER;

architecture RTL of RQ_REGISTER is
	
	--Constants
	constant ALL_ZEROS	:	std_logic_vector(SIZE-1 downto 0) := (others=> '0');
	
	--Signals
	signal T					:	std_logic_vector(2*SIZE-1 downto 0);	-- Signal of registers' data
	signal TRUN				:	std_logic; 										-- Signal to disable writing in registers when RESET goes high

begin
			
	process(CLK)
	begin
		if(CLK'event and CLK='1') then 
			-- When RESET is high, fill registers with zeros
			if(RESET = '1') then
				T		<=	(others=>'0');
				TRUN	<= '0';
			-- When START is high, load N in Q's registers
			elsif(START='1') then
				T		<=	ALL_ZEROS & N;
				TRUN	<= '1';
			else
				if(CE='1' and TRUN='1') then
					-- When SUB is low,	the PARTIAL_SUB is loaded in R's registers
					-- 						while Q's registers are simply shifted left.
					if(SUB='0')	then
						T(2*SIZE-1 	downto SIZE)	<=	PARTIAL_SUB;
						T(SIZE-1 downto 0)		<=	T(SIZE-2 downto 0) & not(BIT_IN);
					else
					-- When SUB is high, all registers are shifted left
						T	<=	T(2*SIZE-2 downto 0) & not(BIT_IN);
					end if;
				end if;
			end if;
		end if;
	end process;
	
	R				<=	T(2*SIZE-1 downto SIZE);
	Q				<=	T(SIZE-1 downto 0);
	PARTIAL_R	<= T(2*SIZE-2 downto SIZE-1);
	-- Please see documentation to understand better why PARTIAL_R is created in that way.

end RTL;