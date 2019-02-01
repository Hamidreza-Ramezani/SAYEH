library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;
--use work.array_package.all;
--library work;

ENTITY Flags IS
	PORT (
	    Cin, Zin, clk, CSet, CReset, ZSet, ZReset, SRload : IN std_logic;
	    Zout,Cout : OUT std_logic
	   	);
END Flags;

ARCHITECTURE dataflow OF Flags IS
		
BEGIN
	PROCESS (clk)
	BEGIN
	IF (clk = '1')THEN
		IF (SRload = '1') THEN
			Zout <= Zin;
			Cout <= Cin;
		ELSE
		IF (ZReset = '1') THEN
			Zout <= '0';
		ELSE IF (ZSet = '1') THEN
			Zout <= '1';
		END IF;
		END IF;
		IF (CReset = '1') THEN
			Cout <= '0';
		ELSE IF (CSet = '1') THEN
			Cout <= '1';
		END IF;
		END IF;
		END IF;

	END IF;
	END PROCESS;
  
END dataflow;
