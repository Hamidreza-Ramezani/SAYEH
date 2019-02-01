library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY ProgramCounter IS
	PORT (
	    EnablePC : IN std_logic;
	    input : IN std_logic_vector (15 DOWNTO 0);
	    clk : IN std_logic;
	    output : OUT std_logic_vector (15 DOWNTO 0)
	);
END ProgramCounter;

ARCHITECTURE dataflow OF ProgramCounter IS BEGIN
	 PROCESS (clk) 
	 BEGIN
		IF (clk = '1') THEN
			IF (EnablePC = '1') THEN
				output <= input;
			END IF;
		END IF;
	END PROCESS;
END dataflow;
