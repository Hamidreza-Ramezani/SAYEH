library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY IR IS
	PORT (
	    IRin : IN std_logic_vector (15 DOWNTO 0);
	    IRout : OUT std_logic_vector (15 DOWNTO 0);
	    clk, IRload : IN std_logic
	);
END IR;

ARCHITECTURE dataflow OF IR IS
	--SIGNAL IRdata : std_logic_vector (15 DOWNTO 0);
BEGIN
	PROCESS (clk) 
	 BEGIN
		IF (clk = '1') THEN
			IF (IRload = '1') THEN
				IRout <= IRin;
			END IF;
		END IF;
	END PROCESS;
	
END dataflow;
