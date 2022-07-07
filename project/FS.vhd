library ieee;
use ieee.std_logic_1164.all;

entity FS is
	port(
		X		: in		std_logic;
		Y		: in		std_logic;
		BIN	: in		std_logic;
		S		: out 	std_logic;
		BOUT	: out 	std_logic
	);
end FS; 

architecture RTL of FS is
begin

	S		<= X xor Y xor BIN;
	BOUT	<= (not(X) and Y) or (not(X) and BIN) or (Y and BIN);

end RTL;