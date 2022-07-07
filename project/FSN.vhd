library ieee;
use ieee.std_logic_1164.all;

entity FSN is

	generic(SIZE:integer);
	port(
			X			: in		std_logic_vector(SIZE-1 downto 0);
			Y			: in		std_logic_vector(SIZE-1 downto 0);
			BIN		: in		std_logic;
			S			: out		std_logic_vector(SIZE-1 downto 0);
			BOUT		: out 	std_logic
	);
	
end FSN;

architecture STRUCT of FSN is

	component FS is
		port(
				X		: in		std_logic;
				Y		: in		std_logic;
				BIN	: in		std_logic;
				S		: out		std_logic;
				BOUT	: out		std_logic
		);
	end component;
	
	signal T : std_logic_vector(SIZE downto 0);
	
begin

	T(0) <= BIN;
	BOUT <= T(SIZE);
	
	GEN: for I in 0 to SIZE-1 generate
		U:	FS port map(
			X			=> X(I),
			Y			=> Y(I),
			BIN		=> T(I),
			S			=> S(I),
			BOUT		=> T(I+1)
		);
	end generate;

end STRUCT;