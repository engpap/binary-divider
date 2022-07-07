library ieee;
use ieee.std_logic_1164.all;

entity COUNT_MANAGER is
	generic(SIZE:integer:=5);
	port(
			CLK			:	in		std_logic;
			RESET			:	in		std_logic;
			CE				:	in		std_logic;									-- To enable counting
			START			:	in		std_logic;									-- To start counting
			COUNT_IN		:	in		std_logic_vector(SIZE-1 downto 0);	-- New count value
			COUNT_OUT	:	out	std_logic_vector(SIZE-1 downto 0);	-- Output count value to update
			EOC			:	out	std_logic;									-- To signal end of count
			DONE			:	out	std_logic									-- To signal end of algorithm
		);

end COUNT_MANAGER;

architecture RTL of COUNT_MANAGER is	 

	-- Constants
	constant ALL_ONES		: std_logic_vector(SIZE-1 downto 0) := (others=> '1');
	constant ALL_ZEROS	: std_logic_vector(SIZE-1 downto 0) := (others=> '0');
	constant ONE			: std_logic_vector(SIZE-1 downto 0) := (0=> '1', others=> '0');
	
	--SIGNALS
	signal TCOUNT			:	std_logic_vector(SIZE-1 downto 0);
	signal TEOC 			:	std_logic;
	signal TDONE			:	std_logic;

begin

	process(CLK)
	begin
		if (CLK' event and CLK='1') then
			-- If reset is 1, initialize count value and set EOC=0 and DONE=0.
			if(RESET = '1') then
				TCOUNT	<= ALL_ONES;
				TEOC		<= '0';
				TDONE		<= '0';
			elsif(CE='1') then
				-- When START is 1, initialize count value and set EOC=0 and DONE=0.
				if (START = '1') then 
					TCOUNT	<= ALL_ONES;
					TEOC		<= '0';
					TDONE		<= '0';
				-- When counting is still allowed
				elsif(TEOC = '0') then
					-- When zero value is reached, end of count must be high
					if(TCOUNT = ALL_ZEROS) then
						TEOC	<= '1';
						TDONE	<= '0';
					-- When zero value is not reached yet, just update count value
					else
						TCOUNT <= COUNT_IN;
						TEOC	<= '0';
						TDONE	<= '0';
					end if; 
				-- When counting is terminated and data is stable, set TDONE high
				-- (on the next clock edge, after reaching count value 0)
				elsif(TEOC <= '1') then
					TDONE	<= '1';
					TEOC	<= '1';
				end if;
			end if;	
		end if;
	end process;
	
	COUNT_OUT	<=	TCOUNT;
	EOC 			<= TEOC;
	DONE 			<= TDONE;
	
end RTL;