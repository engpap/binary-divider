library ieee;
use ieee.std_logic_1164.all;

entity EQUAL_COMPARATOR is
	generic(SIZE:integer:=32);
		port (  
				CLK	:	in		std_logic;
				RESET	:	in		std_logic;
				START	:	in		std_logic;
				X  	:	in		std_logic_vector(SIZE-1 downto 0); 
				Y  	:	in		std_logic_vector(SIZE-1 downto 0); 
				ERROR	:	out	std_logic   
		); 
end EQUAL_COMPARATOR;

architecture RTL of EQUAL_COMPARATOR is
	signal TRUN		:	std_logic; -- To set ERROR on the next clock edge, so input data is surely stable.

begin

	process(CLK)
	begin
		if (CLK' event and CLK='1') then
			if(RESET = '1') then
				ERROR	<=	'0';
				TRUN	<=	'0';
			-- When START is high, set TRUN high so on the next edge ERROR can be assigned.
			elsif(START='1') then
				TRUN	<=	'1';
			-- When START is low and TRUN is high, assign ERROR a value.
			elsif(START='0' and TRUN='1') then
				TRUN	<=	'0';
				if(X=Y) then
					ERROR	<=	'1';
				else
					ERROR <= '0';
				end if;
			end if;
		end if;
	end process;
	
end RTL;